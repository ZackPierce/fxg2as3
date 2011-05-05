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

	// This Class largely based on code pilfered from mx.graphics.RadialGradient
	public class ExpressiveRadialGradientFill extends GradientBase implements IExpressiveFill, ICoordinateSpaceTransformable
	{
		public function ExpressiveRadialGradientFill()
		{
			super();
		}
		
		private static var commonMatrix:Matrix = new Matrix();
		
		//----------------------------------
		//  focalPointRatio
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the focalPointRatio property.
		 */
		private var _focalPointRatio:Number = 0.0;
		
		[Bindable("propertyChange")]
		[Inspectable(category="General")]
		
		
		public function get focalPointRatio():Number
		{
			return _focalPointRatio;
		}
		
		public function set focalPointRatio(value:Number):void
		{
			var oldValue:Number = _focalPointRatio;
			if (value != oldValue)
			{
				_focalPointRatio = value;
				
				dispatchGradientChangedEvent("focalPointRatio", oldValue, value);
			}
		} 
		
		override public function set matrix(value:Matrix):void
		{
			scaleX = NaN;
			scaleY = NaN;
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
		
		//----------------------------------
		//  scaleY
		//----------------------------------
		
		private var _scaleY:Number;
		
		[Bindable("propertyChange")]
		[Inspectable(category="General")]
		
		public function get scaleY():Number
		{
			return compoundTransform ? compoundTransform.scaleY : _scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			if (value != scaleY)
			{
				var oldValue:Number = scaleY;
				
				if (compoundTransform)
				{
					// If we have a compoundTransform, only non-NaN values are allowed
					if (!isNaN(value))
						compoundTransform.scaleY = value;
				}
				else
				{
					_scaleY = value;
				}
				dispatchGradientChangedEvent("scaleY", oldValue, value);
			}
		}
		
		public function getBeginningAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle, targetFlex3:Boolean):String
		{
			// TBD - Determine if targetOrigin should ever be explicitly set
			var targetOrigin:Point = new Point();
			
			var w:Number = !isNaN(scaleX) ? scaleX : targetBounds.width;
			var h:Number = !isNaN(scaleY) ? scaleY : targetBounds.height;
			var regX:Number =  !isNaN(x) ? x + targetOrigin.x : targetBounds.left + targetBounds.width / 2;
			var regY:Number =  !isNaN(y) ? y + targetOrigin.y : targetBounds.top + targetBounds.height / 2;
			
			commonMatrix.identity();
			
			if (!compoundTransform)
			{
				commonMatrix.scale (w / GRADIENT_DIMENSION, h / GRADIENT_DIMENSION);
				commonMatrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
				commonMatrix.translate(regX, regY);						
			}
			else
			{            
				commonMatrix.scale(1 / GRADIENT_DIMENSION, 1 / GRADIENT_DIMENSION);
				commonMatrix.concat(compoundTransform.matrix);
				commonMatrix.translate(targetOrigin.x, targetOrigin.y);
			}
			
			return '\n' + targetGraphicsIdentifier + '.beginGradientFill(GradientType.RADIAL, ' 
				+ FXGConverter.getExecutableArrayString(colors, function(colorValue:Number):String {return FXGConverter.convertColorUintToHexString(uint(colorValue));}) + ', ' 
				+ FXGConverter.getExecutableArrayString(alphas) + ', ' 
				+ FXGConverter.getExecutableArrayString(ratios, function(number:Number):String { return int(number).toString();}) + ', '
				+ CoordinateSpaceTransformableUtil.matrixToAS3String(commonMatrix) +', "' + spreadMethod + '", "' + interpolationMethod + '", ' + focalPointRatio + ');';
		}
		
		public function getEndingAS3String(targetGraphicsIdentifier:String):String
		{
			return '\n' + targetGraphicsIdentifier + '.endFill();';
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty('@focalPointRatio'))
			{
				this.focalPointRatio = Number(fxgNode.@focalPointRatio.toString());
			}
			this.entries = ExpressiveGradientUtil.generateGradientEntryArray(fxgNode);
			CoordinateSpaceTransformableUtil.populateCoordinateSpaceTransformableFromFXG(this, fxgNode, false);
			ExpressiveGradientUtil.parseGradientSpreadAndInterpolationFromFXG(this, fxgNode);
		}
		
		public function expressiveClone(namingTracker:NamingTracker = null):IExpressiveFill
		{
			var sink:ExpressiveRadialGradientFill = new ExpressiveRadialGradientFill();
			sink.focalPointRatio = this.focalPointRatio;
			sink.entries = ExpressiveGradientUtil.cloneGradientEntryArray(this.entries);
			CoordinateSpaceTransformableUtil.transferDuplicateCoordinateSpaceProperties(this, sink);
			return sink;
		}
	}
}