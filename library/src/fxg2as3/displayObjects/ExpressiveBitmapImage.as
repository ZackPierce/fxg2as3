package fxg2as3.displayObjects
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import fxg2as3.CoordinateSpaceTransformableUtil;
	import fxg2as3.ISourceBitmapUser;
	import fxg2as3.NamingTracker;
	import fxg2as3.graphics.ExpressiveBitmapFill;
	
	import mx.graphics.BitmapFillMode;
	
	public class ExpressiveBitmapImage extends ExpressiveDisplayObject implements ISourceBitmapUser
	{
		
		public var width:Number;
		public var height:Number;
		public var fillMode:String = BitmapFillMode.SCALE;
		[Bindable] public var bitmapSourcePath:String;
		[Bindable] public var referenceBitmapData:BitmapData;
		// TBD - change reference to property function, so we can grab the width/height when it is set
		
		public function ExpressiveBitmapImage()
		{
			super();
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			if (fxgNode.hasOwnProperty('@width'))
			{
				this.width = Number(fxgNode.@width.toString());
			}
			if (fxgNode.hasOwnProperty('@height'))
			{
				this.height = Number(fxgNode.@height.toString());
			}
			if (fxgNode.hasOwnProperty('@fillMode'))
			{
				this.fillMode = fxgNode.@fillMode.toString();
			}
			if (fxgNode.hasOwnProperty('@source')) {
				this.bitmapSourcePath = ExpressiveBitmapFill.extractSourcePathFromEmbedDirective(fxgNode.@source.toString());
			}
		}
		
		override public function getInstanceName():String
		{
			return explicitId ? explicitId : "image" + trackingId;
		}
		
		override public function getInstantiationAS3(targetFlex3:Boolean):String
		{
			return '\nvar ' + this.getInstanceName() + ':Shape = new Shape();';
		}
		
		override public function getDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var drawingAS3:String = '';
			var sourceAsBitmapData:BitmapData = referenceBitmapData;
			var repeatFill:Boolean = (fillMode == BitmapFillMode.REPEAT);
			var assetName:String = 'asset' + trackingId;
			drawingAS3 += '\n[Embed(source="' + bitmapSourcePath + '")] var ' + assetName + ':Class;';
			
			if (!sourceAsBitmapData) {
				drawingAS3 += '\n' + this.getInstanceName() + '.graphics.lineStyle();';
				drawingAS3 += '\n' + this.getInstanceName() + '.graphics.beginBitmapFill(new ' + assetName + '().bitmapData, ' + CoordinateSpaceTransformableUtil.matrixToAS3String(matrix) + ', ' + repeatFill + '); // Positioned without use of the original image';
				drawingAS3 += '\n' + this.getInstanceName() + '.graphics.drawRect(0, 0, ' + width + ', ' + height + ');';
				drawingAS3 += '\n' + this.getInstanceName() + '.graphics.endFill();';
				return drawingAS3; // Early return if we can't conduct the necessary calculations
			}
			
			var repeatBitmap:Boolean = false;
			var fillScaleX:Number = 1;
			var fillScaleY:Number = 1;
			var roundedDrawX:Number = 0;
			var roundedDrawY:Number = 0;
			var fillWidth:Number = width;
			var fillHeight:Number = height;
			
			switch(fillMode)
			{
				case BitmapFillMode.REPEAT: 
					if (sourceAsBitmapData)
					{
						repeatBitmap = true;
					}    
					break;
				
				case BitmapFillMode.SCALE:
					if (sourceAsBitmapData)
					{
						fillScaleX = width / sourceAsBitmapData.width;
						fillScaleY = height / sourceAsBitmapData.height;
					}
					break;
				
				case BitmapFillMode.CLIP:
					if (sourceAsBitmapData)
					{
						fillWidth = Math.min(width, sourceAsBitmapData.width);
						fillHeight = Math.min(height, sourceAsBitmapData.height);
					}
					break;
			}
			
			var transformMatrix:Matrix = new Matrix();
			transformMatrix.identity();
			transformMatrix.scale(fillScaleX, fillScaleY);
			transformMatrix.translate(roundedDrawX, roundedDrawY);
			
			// TBD - add support for scale-9 grid
			drawingAS3 += '\n' + this.getInstanceName() + '.graphics.lineStyle();';
			drawingAS3 += '\n' + this.getInstanceName() + '.graphics.beginBitmapFill( new ' + assetName + '().bitmapData, ' + CoordinateSpaceTransformableUtil.matrixToAS3String(transformMatrix) + ', ' + repeatBitmap + ', false);'; 
			drawingAS3 += '\n' + this.getInstanceName() + '.graphics.drawRect(' + roundedDrawX + ', ' + roundedDrawY + ', ' + fillWidth + ', ' + fillHeight + ');';
			drawingAS3 += '\n' + this.getInstanceName() + '.graphics.endFill();';
			return drawingAS3;
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshImage:ExpressiveBitmapImage = new ExpressiveBitmapImage();
			freshImage.trackingId = namingTracker.getNextId();
			CoordinateSpaceTransformableUtil.transferDuplicateCoordinateSpaceProperties(this, freshImage);
			freshImage.fillMode = this.fillMode;
			freshImage.bitmapSourcePath = this.bitmapSourcePath;
			freshImage.width = this.width;
			freshImage.height = this.height;
			return freshImage;
		}
	}
}