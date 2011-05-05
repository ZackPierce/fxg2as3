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

	public class ExpressiveRadialGradientStroke extends GradientStroke implements IExpressiveStroke, ICoordinateSpaceTransformable
	{
		
		public function ExpressiveRadialGradientStroke(weight:Number = 1,
													   pixelHinting:Boolean = false,
													   scaleMode:String = "normal",
													   caps:String = "round",
													   joints:String = "round",
													   miterLimit:Number = 3)
		{
			super(weight, pixelHinting, scaleMode, caps, joints, miterLimit);
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
		
		/**
		 *  Sets the location of the start of the radial fill.
		 *
		 *  <p>Valid values are from <code>-1.0</code> to <code>1.0</code>.
		 *  A value of <code>-1.0</code> sets the focal point
		 *  (or, start of the gradient fill)
		 *  on the left of the bounding Rectangle.
		 *  A value of <code>1.0</code> sets the focal point
		 *  on the right of the bounding Rectangle.
		 *  
		 *  <p>If you use this property in conjunction
		 *  with the <code>angle</code> property, 
		 *  this value specifies the degree of distance
		 *  from the center that the focal point occurs. 
		 *  For example, with an angle of 45
		 *  and <code>focalPointRatio</code> of 0.25,
		 *  the focal point is slightly lower and to the right of center.
		 *  If you set <code>focalPointRatio</code> to <code>0</code>,
		 *  the focal point is in the middle of the bounding Rectangle.</p>
		 *  If you set <code>focalPointRatio</code> to <code>1</code>,
		 *  the focal point is all the way to the bottom right corner
		 *  of the bounding Rectangle.</p>
		 *
		 *  @default 0.0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get focalPointRatio():Number
		{
			return _focalPointRatio;
		}
		
		/**
		 *  @private
		 */
		public function set focalPointRatio(value:Number):void
		{
			var oldValue:Number = _focalPointRatio;
			if (value != oldValue)
			{
				_focalPointRatio = value;
				
				dispatchGradientChangedEvent("focalPointRatio",
					oldValue, value);
			}
		}
		
		override public function set matrix(value:Matrix):void
		{
			scaleX = NaN;
			scaleY = NaN;
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
		
		private function calculateTransformationMatrix(targetBounds:Rectangle, matrix:Matrix, targetOrigin:Point):void
		{
			matrix.identity();
			
			if (!compoundTransform)
			{   
				var w:Number = !isNaN(scaleX) ? scaleX : targetBounds.width;
				var h:Number = !isNaN(scaleY) ? scaleY : targetBounds.height;
				var regX:Number = !isNaN(x) ? x + targetOrigin.x : targetBounds.left + targetBounds.width / 2;
				var regY:Number = !isNaN(y) ? y + targetOrigin.y : targetBounds.top + targetBounds.height / 2;
				
				matrix.scale (w / GRADIENT_DIMENSION, h / GRADIENT_DIMENSION);
				matrix.rotate(!isNaN(_angle) ? _angle : rotationInRadians);
				matrix.translate(regX, regY);	    
			}             
			else
			{                     
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
			if (fxgNode.hasOwnProperty('@focalPointRatio'))
			{
				this.focalPointRatio = Number(fxgNode.@focalPointRatio.toString());
			}
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
				+ CoordinateSpaceTransformableUtil.matrixToAS3String(commonMatrix) +', "' + spreadMethod + '", "' + interpolationMethod 
				+ '", ' + focalPointRatio + ');';
			return lineStyleCode;
		}
		
		public function expressiveClone(namingTracker:NamingTracker = null):IExpressiveStroke
		{
			var sink:ExpressiveRadialGradientStroke = new ExpressiveRadialGradientStroke(this.weight, this.pixelHinting, this.scaleMode, this.caps, this.joints, this.miterLimit);
			sink.entries = ExpressiveGradientUtil.cloneGradientEntryArray(this.entries);
			CoordinateSpaceTransformableUtil.transferDuplicateCoordinateSpaceProperties(this, sink);
			sink.interpolationMethod = this.interpolationMethod;
			sink.spreadMethod = this.spreadMethod;
			sink.focalPointRatio = this.focalPointRatio;
			return sink;
		}
	}
}