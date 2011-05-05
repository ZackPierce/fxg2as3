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
	import mx.graphics.GradientBase;
	
	use namespace mx_internal;

	// This Class largely based on code pilfered from mx.graphics.LinearGradient
	public class ExpressiveLinearGradientFill extends GradientBase implements IExpressiveFill, ICoordinateSpaceTransformable
	{
		[Bindable] public var scaleY:Number = 1;
		
		public function ExpressiveLinearGradientFill()
		{
			super();
		}
		
		private static var commonMatrix:Matrix = new Matrix();
		
		override public function set matrix(value:Matrix):void
		{
			scaleX = NaN;
			super.matrix = value;
		}
		
		//----------------------------------
		//  scaleX
		//----------------------------------
		
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
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			this.entries = ExpressiveGradientUtil.generateGradientEntryArray(fxgNode);
			CoordinateSpaceTransformableUtil.populateCoordinateSpaceTransformableFromFXG(this, fxgNode, false);
			ExpressiveGradientUtil.parseGradientSpreadAndInterpolationFromFXG(this, fxgNode);
		}
		
		
		public function getBeginningAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle, targetFlex3:Boolean):String
		{
			// TBD - Determine if targetOrigin should ever be explicitly set
			var targetOrigin:Point = new Point();
			
			commonMatrix.identity();
			
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
					commonMatrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2); // 1638.4 / 2
				
				// Force the length to a absolute minimum of 2. Values of 0, 1, or -1 have undesired behavior	
				if (length >= 0 && length < 2)
					length = 2;
				else if (length < 0 && length > -2)
					length = -2;
				
				// Scale the gradient in the x direction. The natural size is 1638.4px. No need
				// to scale the y direction because it is infinite
				commonMatrix.scale (length / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				
				commonMatrix.rotate (!isNaN(_angle) ? _angle : rotationInRadians);
				if (isNaN(tx))
					tx = targetBounds.left + targetBounds.width / 2;
				else
					tx += targetOrigin.x;
				if (isNaN(ty))
					ty = targetBounds.top + targetBounds.height / 2;
				else
					ty += targetOrigin.y;
				commonMatrix.translate(tx, ty);	
			}
			else
			{
				commonMatrix.translate(GRADIENT_DIMENSION / 2, GRADIENT_DIMENSION / 2);
				commonMatrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				commonMatrix.concat(compoundTransform.matrix);
				commonMatrix.translate(targetOrigin.x, targetOrigin.y);
			}			 
			
			var colorsArrayCode:String = '[';
			for (var c:int = 0; c < colors.length; c++)
			{
				colorsArrayCode += FXGConverter.convertColorUintToHexString(colors[c]);
				if (c < colors.length - 1)
				{
					colorsArrayCode += ', ';
				}
			}
			colorsArrayCode += ']';
			
			return '\n' + targetGraphicsIdentifier + '.beginGradientFill(GradientType.LINEAR, ' 
				+ FXGConverter.getExecutableArrayString(colors, function(colorValue:Number):String {return FXGConverter.convertColorUintToHexString(uint(colorValue));}) + ', ' 
				+ FXGConverter.getExecutableArrayString(alphas) + ', ' 
				+ FXGConverter.getExecutableArrayString(ratios, function(number:Number):String { return int(number).toString();}) + ', '
				+ CoordinateSpaceTransformableUtil.matrixToAS3String(commonMatrix) +', "' + spreadMethod + '", "' + interpolationMethod + '");';
			
		}
		
		public function getEndingAS3String(targetGraphicsIdentifier:String):String
		{
			return '\n' + targetGraphicsIdentifier + '.endFill();';
		}
		
		public function expressiveClone(namingTracker:NamingTracker = null):IExpressiveFill
		{
			var sink:ExpressiveLinearGradientFill = new ExpressiveLinearGradientFill();
			sink.entries = ExpressiveGradientUtil.cloneGradientEntryArray(this.entries);
			CoordinateSpaceTransformableUtil.transferDuplicateCoordinateSpaceProperties(this, sink);
			return sink;
		}
	}
}