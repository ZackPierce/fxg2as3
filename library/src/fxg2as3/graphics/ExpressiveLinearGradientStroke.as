package fxg2as3.graphics
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.CoordinateSpaceTransformableUtil;
	import fxg2as3.ExpressiveGradientUtil;
	import fxg2as3.FXGConverter;
	import fxg2as3.ICoordinateSpaceTransformable;
	import fxg2as3.NamingTracker;
	
	import mx.core.mx_internal;
	import mx.graphics.GradientStroke;
	
	use namespace mx_internal;
	
	// Code in this Class largely pilfered from mx.graphics.LinearGradientStroke
	public class ExpressiveLinearGradientStroke extends GradientStroke implements IExpressiveStroke, ICoordinateSpaceTransformable
	{
		[Bindable] public var scaleY:Number;
		
		public function ExpressiveLinearGradientStroke(weight:Number = 1,
													   pixelHinting:Boolean = false,
													   scaleMode:String = "normal",
													   caps:String = "round",
													   joints:String = "round",
													   miterLimit:Number = 3)
		{
			super(weight, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
		/**
		 *  @private
		 */
		private static var commonMatrix:Matrix = new Matrix();
		
		override public function set matrix(value:Matrix):void
		{
			scaleX = NaN;
			super.matrix = value;
		}
		
		private var _scaleX:Number;
		
		[Bindable("propertyChange")]
		[Inspectable(category="General")]
		
		public function get scaleX():Number
		{
			return compoundTransform ? compoundTransform.scaleX : _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			if (value != scaleX)
			{
				var oldValue:Number = scaleX;
				
				if (compoundTransform)
				{
					// If we have a compoundTransform, only non-NaN values are allowed
					if (!isNaN(value))
						compoundTransform.scaleX = value;
				}
				else
				{
					_scaleX = value;
				}
				dispatchGradientChangedEvent("scaleX", oldValue, value);
			}
		}
		
		private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point):void
		{        
			matrix.identity();
			
			if (!compoundTransform)
			{
				var tx:Number = x;
				var ty:Number = y;
				var length:Number = scaleX;
				
				if (isNaN(length))
				{
					// Figure out the two sides
					if (rotation % 90 != 0)
					{			
						// Normalize angles with absolute value > 360 
						var normalizedAngle:Number = rotation % 360;
						// Normalize negative angles
						if (normalizedAngle < 0)
							normalizedAngle += 360;
						
						// Angles wrap at 180
						normalizedAngle %= 180;
						
						// Angles > 90 get mirrored
						if (normalizedAngle > 90)
							normalizedAngle = 180 - normalizedAngle;
						
						var side:Number = targetBounds.width;
						// Get the hypotenuse of the largest triangle that can fit in the bounds
						var hypotenuse:Number = Math.sqrt(targetBounds.width * targetBounds.width + targetBounds.height * targetBounds.height);
						// Get the angle of that largest triangle
						var hypotenuseAngle:Number =  Math.acos(targetBounds.width / hypotenuse) * 180 / Math.PI;
						
						// If the angle is larger than the hypotenuse angle, then use the height 
						// as the adjacent side of the triangle
						if (normalizedAngle > hypotenuseAngle)
						{
							normalizedAngle = 90 - normalizedAngle;
							side = targetBounds.height;
						}
						
						// Solve for the hypotenuse given an adjacent side and an angle. 
						length = side / Math.cos(normalizedAngle / 180 * Math.PI);
					}
					else 
					{
						// Use either width or height based on the rotation
						length = (rotation % 180) == 0 ? targetBounds.width : targetBounds.height;
					}
				}
				
				// If only x or y is defined, force the other to be set to 0
				if (!isNaN(tx) && isNaN(ty))
					ty = 0;
				else if (isNaN(tx) && !isNaN(ty))
					tx = 0;
				
				// If x and y are specified, then move the gradient so that the
				// top left corner is at 0,0
				if (!isNaN(tx) && !isNaN(ty))
					matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2); // 1638.4 / 2
				
				// Force the length to a absolute minimum of 2. Values of 0, 1, or -1 have undesired behavior	
				if (length >= 0 && length < 2)
					length = 2;
				else if (length < 0 && length > -2)
					length = -2;
				
				// Scale the gradient in the x direction. The natural size is 1638.4px. No need
				// to scale the y direction because it is infinite
				matrix.scale (length / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				
				matrix.rotate (!isNaN(_angle) ? _angle : rotationInRadians);
				if (isNaN(tx))
					tx = targetBounds.left + targetBounds.width / 2;
				else
					tx += targetOrigin.x;
				if (isNaN(ty))
					ty = targetBounds.top + targetBounds.height / 2;
				else
					ty += targetOrigin.y;
				matrix.translate(tx, ty);	
			}
			else
			{
				matrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2);
				matrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				matrix.concat(compoundTransform.matrix);
				matrix.translate(targetOrigin.x, targetOrigin.y);
			}			 	
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			this.entries = ExpressiveGradientUtil.generateGradientEntryArray(fxgNode);
			CoordinateSpaceTransformableUtil.populateCoordinateSpaceTransformableFromFXG(this, fxgNode, false);
			ExpressiveStrokeUtil.parseStrokePropertiesFromFXG(this, fxgNode);
			ExpressiveGradientUtil.parseGradientSpreadAndInterpolationFromFXG(this, fxgNode);
		}
		
		public function getAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle):String
		{
			var targetOrigin:Point = new Point();
			var lineStyleCode:String = '';
			
			commonMatrix.identity();
			
			lineStyleCode += '\n' + targetGraphicsIdentifier + '.lineStyle(' + weight + ', 0, 1, ' + pixelHinting +', "' + scaleMode + '", "' + caps + '", "' + joints + '", ' + miterLimit + ');';
			
			if (targetBounds)
				calculateTransformationMatrix(targetBounds, commonMatrix, targetOrigin); 
			
			lineStyleCode += '\n' + targetGraphicsIdentifier + '.lineGradientStyle(GradientType.LINEAR, ' 
				+ FXGConverter.getExecutableArrayString(colors, function(colorValue:Number):String {return FXGConverter.convertColorUintToHexString(uint(colorValue));}) + ', ' 
				+ FXGConverter.getExecutableArrayString(alphas) + ', ' 
				+ FXGConverter.getExecutableArrayString(ratios, function(number:Number):String { return int(number).toString();}) + ', '
				+ CoordinateSpaceTransformableUtil.matrixToAS3String(commonMatrix) +', "' + spreadMethod + '", "' + interpolationMethod + '");';
			
			return lineStyleCode;
		}
		
		public function expressiveClone(namingTracker:NamingTracker = null):IExpressiveStroke
		{
			var sink:ExpressiveLinearGradientStroke = new ExpressiveLinearGradientStroke(this.weight, this.pixelHinting, this.scaleMode, this.caps, this.joints, this.miterLimit);
			sink.entries = ExpressiveGradientUtil.cloneGradientEntryArray(this.entries);
			CoordinateSpaceTransformableUtil.transferDuplicateCoordinateSpaceProperties(this, sink);
			sink.interpolationMethod = this.interpolationMethod;
			sink.spreadMethod = this.spreadMethod;
			return sink;
		}
	}
}