package fxg2as3.graphics
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.CoordinateSpaceTransformableUtil;
	import fxg2as3.ICoordinateSpaceTransformable;
	import fxg2as3.ISourceBitmapUser;
	import fxg2as3.NamingTracker;
	
	import mx.graphics.BitmapFill;
	import mx.graphics.BitmapFillMode;
	import mx.utils.MatrixUtil;
	
	public class ExpressiveBitmapFill extends BitmapFill implements IExpressiveFill, ICoordinateSpaceTransformable, ISourceBitmapUser
	{
		[Bindable] public var bitmapSourcePath:String;
		[Bindable] public var referenceBitmapData:BitmapData; // Populated by some external app class, most likely by using the AIR file libraries
		// TBD - change reference to property function, so we can grab the width/height when it is set
		
		public var parentTrackingId:int;
		
		private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
		
		private var regenerateNonRepeatSource:Boolean = true;
		private var nonRepeatAlphaSource:BitmapData;
		private var lastBoundsWidth:Number = 0;
		private var lastBoundsHeight:Number = 0;
		private var nonRepeatSourceCreated:Boolean = false;
		
		public function ExpressiveBitmapFill()
		{
			super();
		}
		
		// This method largely pilfered from BitmapFill.begin.
		public function getBeginningAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle, targetFlex3:Boolean):String
		{
			// Without access to the actual image bitmap data, it is impossible to fully implement the bitmap fill transformations
			var sourceAsBitmapData:BitmapData = referenceBitmapData;
			var fillAS3:String = '';
			var repeatFill:Boolean = (fillMode == BitmapFillMode.REPEAT); 
			fillAS3 += '\n[Embed(source="' + bitmapSourcePath + '")] var asset' + parentTrackingId + ':Class;';
			
			if (!sourceAsBitmapData) {
				fillAS3 += '\n' + targetGraphicsIdentifier + '.beginBitmapFill(new asset' + parentTrackingId + '().bitmapData, ' + CoordinateSpaceTransformableUtil.matrixToAS3String(matrix) + ', ' + repeatFill + '); // Positioned without use of the original image';
				return fillAS3; // Early return if we can't conduct the necessary calculations
			}
			
			var targetOrigin:Point = new Point();
			var transformMatrix:Matrix = new Matrix();
			var applyAlphaMultiplier:Boolean = alpha != 1;
			
			if (compoundTransform)
			{
				transformMatrix = compoundTransform.matrix;
				transformMatrix.translate(targetOrigin.x, targetOrigin.y);
			}
			else
			{
				// Calculate default scaleX, scaleY
				var defaultScaleX:Number = scaleX;
				var defaultScaleY:Number = scaleY;
				
				// If fillMode is scale then scale to fill the content area  
				if (fillMode == BitmapFillMode.SCALE)
				{
					// calculate defaultScaleX only if explicit scaleX is not specified
					if (isNaN(scaleX) && sourceAsBitmapData.width > 0)
						defaultScaleX = targetBounds.width / sourceAsBitmapData.width;
					
					// calculate defaultScaleY if it's not already specified
					if (isNaN(scaleY) && sourceAsBitmapData.height > 0)
						defaultScaleY = targetBounds.height / sourceAsBitmapData.height;
				}
				
				if (isNaN(defaultScaleX))
					defaultScaleX = 1;
				if (isNaN(defaultScaleY))
					defaultScaleY = 1;
				
				// Calculate default x, y
				var regX:Number =  !isNaN(x) ? x + targetOrigin.x : targetBounds.left;
				var regY:Number =  !isNaN(y) ? y + targetOrigin.y : targetBounds.top;
				
				transformMatrix.identity();
				transformMatrix.translate(-transformX, -transformY);
				transformMatrix.scale(defaultScaleX, defaultScaleY);
				transformMatrix.rotate(rotation * RADIANS_PER_DEGREES);
				transformMatrix.translate(regX + transformX, regY + transformY);
			}
			
			// If repeat is true, fillMode is repeat, or if the source bitmap size  
			// equals or exceeds the targetBounds, just use the source bitmap
			if (repeatFill || 
				(MatrixUtil.isDeltaIdentity(transformMatrix) && 
					transformMatrix.tx == targetBounds.left &&
					transformMatrix.ty == targetBounds.top &&
					targetBounds.width <= sourceAsBitmapData.width && 
					targetBounds.height <= sourceAsBitmapData.height))
			{
				if (nonRepeatAlphaSource && nonRepeatSourceCreated)
				{
					nonRepeatAlphaSource.dispose();
					nonRepeatAlphaSource = null;
					applyAlphaMultiplier = alpha != 1;
				}
				
				nonRepeatSourceCreated = false;
			}
			else if (fillMode == BitmapFillMode.CLIP)
			{
				// Regenerate the nonRepeatSource if it wasn't previously created or if the bounds 
				// dimensions have changed.
				if (regenerateNonRepeatSource || 
					lastBoundsWidth != targetBounds.width || 
					lastBoundsHeight != targetBounds.height)
				{
					// Release the old bitmap data
					if (nonRepeatAlphaSource)
						nonRepeatAlphaSource.dispose();
					
					var bitmapTopLeft:Point = new Point();
					// We want the top left corner of the bitmap to be at (0,0) when we copy it. 
					// Save the translation and reapply it after the we have copied the bitmap
					var tx:Number = transformMatrix.tx;
					var ty:Number = transformMatrix.ty; 
					
					transformMatrix.tx = 0;
					transformMatrix.ty = 0;
					
					// Get the bounds of the transformed bitmap (minus translation)
					var bitmapSize:Point = MatrixUtil.transformBounds(
						sourceAsBitmapData.width, sourceAsBitmapData.height, 
						transformMatrix, 
						bitmapTopLeft);
					
					// Get the size of the bitmap using the bounds              
					// Pad the new bitmap size so that the borders are empty
					var newW:Number = Math.ceil(bitmapSize.x) + 2;
					var newY:Number = Math.ceil(bitmapSize.y) + 2;
					
					// Translate a rotated bitmap to ensure that the top left post-transformed corner is at (1,1)
					transformMatrix.translate(1 - bitmapTopLeft.x, 1 - bitmapTopLeft.y);
					
					// Draw the transformed bitmapData into a new bitmapData that is the size of the bounds
					// This will prevent the edge pixels getting repeated to fill the empty space
					nonRepeatAlphaSource = new BitmapData(newW, newY, true, 0xFFFFFF);
					nonRepeatAlphaSource.draw(sourceAsBitmapData, transformMatrix, null, null, null, smooth);
					
					// The transform matrix has already been applied to the source, so just use identity
					// for the beginBitmapFill call
					transformMatrix.identity();
					// We need to restore both the matrix translation and the rotation translation
					transformMatrix.translate(tx + bitmapTopLeft.x - 1, ty + bitmapTopLeft.y - 1);
					// Save off the bounds so we can compare it the next time this function is called
					lastBoundsWidth = targetBounds.width;
					lastBoundsHeight = targetBounds.height;
					
					nonRepeatSourceCreated = true;
					
					// Reapply the alpha if alpha is not 1.
					applyAlphaMultiplier = alpha != 1;
				}
			}
			
			// Apply the alpha to a clone of the source. We don't want to modify the actual source because applying the alpha 
			// will modify the source and we have no way to restore the source back its original alpha value. 
			if (applyAlphaMultiplier)
			{
				// Clone the bitmapData if we didn't already make a copy for CLIP mode
				if (!nonRepeatAlphaSource)
					nonRepeatAlphaSource = sourceAsBitmapData.clone();
				
				var ct:ColorTransform = new ColorTransform();
				ct.alphaMultiplier = alpha;
				
				nonRepeatAlphaSource.colorTransform(new Rectangle(0, 0, nonRepeatAlphaSource.width, nonRepeatAlphaSource.height), ct);
				applyAlphaMultiplier = false;
			}
			
			// If we have a nonRepeatAlphaSource, then use it. Otherwise, we just use the source. 
			if (nonRepeatAlphaSource)
				sourceAsBitmapData = nonRepeatAlphaSource;
			
			fillAS3 += '\n' + targetGraphicsIdentifier + '.beginBitmapFill(new asset' + parentTrackingId + '().bitmapData, ' + CoordinateSpaceTransformableUtil.matrixToAS3String(transformMatrix) + ', ' + repeatFill + ', ' + smooth + ');';
			
			return fillAS3;
		}
		
		public function getEndingAS3String(targetGraphicsIdentifier:String):String
		{
			return targetGraphicsIdentifier + '.endFill();';
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			parentTrackingId = namingTracker.getCurrentId();
			CoordinateSpaceTransformableUtil.populateCoordinateSpaceTransformableFromFXG(this, fxgNode, false);
			if (fxgNode.hasOwnProperty('@fillMode'))
			{
				this.fillMode = fxgNode.@fillMode.toString();
			}
			if (fxgNode.hasOwnProperty('@source'))
			{
				bitmapSourcePath = extractSourcePathFromEmbedDirective(fxgNode.@source.toString());
			}
		}
		
		public static function extractSourcePathFromEmbedDirective(pEmbedDirective:String):String
		{
			// Drag path out of embed directive, which looks like: @Embed('somefolder/filename.png') 
			var singleQuotePattern:RegExp = /@Embed\('([\w\.\/]+)'\)/;
			var captures:Array = singleQuotePattern.exec(pEmbedDirective) as Array;
			if (captures && captures.length > 1)
			{
				return captures[1] as String;
			}
			else
			{
				return '';
			}
		}
		
		public function expressiveClone(namingTracker:NamingTracker = null):IExpressiveFill
		{
			var freshFill:ExpressiveBitmapFill = new ExpressiveBitmapFill();
			freshFill.parentTrackingId = namingTracker.getCurrentId();
			CoordinateSpaceTransformableUtil.transferDuplicateCoordinateSpaceProperties(this, freshFill);
			freshFill.fillMode = this.fillMode;
			freshFill.bitmapSourcePath = this.bitmapSourcePath;
			return freshFill;
		}
	}
}