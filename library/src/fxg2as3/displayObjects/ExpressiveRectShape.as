package fxg2as3.displayObjects
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;

	public class ExpressiveRectShape extends ExpressiveShape
	{
		public var width:Number = 0;
		public var height:Number = 0;
		
		public var radiusX:Number = 0;
		public var radiusY:Number = 0;
		
		// These corner radius values default to NaN
		public var topLeftRadiusX:Number;
		public var topLeftRadiusY:Number;
		
		public var topRightRadiusX:Number;
		public var topRightRadiusY:Number;
		
		public var bottomLeftRadiusX:Number;
		public var bottomLeftRadiusY:Number;
		
		public var bottomRightRadiusX:Number;
		public var bottomRightRadiusY:Number;
		
		public function ExpressiveRectShape()
		{
			super();
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			parseRectProperties(fxgNode);
		}
		
		public function parseRectProperties(fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty('@width'))
			{
				width = Number(fxgNode.@width.toString());
			}
			if (fxgNode.hasOwnProperty('@height'))
			{
				height = Number(fxgNode.@height.toString());
			}
			if (fxgNode.hasOwnProperty('@radiusX'))
			{
				radiusX = Number(fxgNode.@radiusX.toString());
			}
			if (fxgNode.hasOwnProperty('@radiusY'))
			{
				radiusY = Number(fxgNode.@radiusY.toString());
			}
			if (fxgNode.hasOwnProperty('@topLeftRadiusX'))
			{
				topLeftRadiusX = Number(fxgNode.@topLeftRadiusX.toString());
			}
			if (fxgNode.hasOwnProperty('@topLeftRadiusY'))
			{
				topLeftRadiusY = Number(fxgNode.@topLeftRadiusY.toString());
			}
			if (fxgNode.hasOwnProperty('@topRightRadiusX'))
			{
				topRightRadiusX = Number(fxgNode.@topRightRadiusX.toString());
			}
			if (fxgNode.hasOwnProperty('@topRightRadiusY'))
			{
				topRightRadiusY = Number(fxgNode.@topRightRadiusY.toString());
			}
			if (fxgNode.hasOwnProperty('@bottomLeftRadiusX'))
			{
				bottomLeftRadiusX = Number(fxgNode.@bottomLeftRadiusX.toString());
			}
			if (fxgNode.hasOwnProperty('@bottomLeftRadiusY'))
			{
				bottomLeftRadiusY = Number(fxgNode.@bottomLeftRadiusY.toString());
			}
			if (fxgNode.hasOwnProperty('@bottomRightRadiusX'))
			{
				bottomRightRadiusX = Number(fxgNode.@bottomRightRadiusX.toString());
			}
			if (fxgNode.hasOwnProperty('@bottomRightRadiusY'))
			{
				bottomRightRadiusY = Number(fxgNode.@bottomRightRadiusY.toString());
			}
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshShape:ExpressiveRectShape = new ExpressiveRectShape();
			freshShape.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshShape, namingTracker);
			transferDuplicateShapeProperties(this, freshShape, namingTracker);
			transferDuplicateRectShapeProperties(this, freshShape, namingTracker);
			return freshShape;
		}
		
		public static function transferDuplicateRectShapeProperties(source:ExpressiveRectShape, sink:ExpressiveRectShape, namingTracker:NamingTracker):void
		{
			sink.width = source.width;
			sink.height = source.height;
			sink.radiusX = source.radiusX;
			sink.radiusY = source.radiusY;
			sink.topLeftRadiusX = source.topLeftRadiusX;
			sink.topLeftRadiusY = source.topLeftRadiusY;
			sink.topRightRadiusX = source.topRightRadiusX;
			sink.topRightRadiusY = source.topRightRadiusY;
			sink.bottomLeftRadiusX = source.bottomLeftRadiusX;
			sink.bottomLeftRadiusY = source.bottomLeftRadiusY;
			sink.bottomRightRadiusX = source.bottomRightRadiusX;
			sink.bottomRightRadiusY = source.bottomRightRadiusY;
		}
		
		override public function getShapeBounds():Rectangle
		{
			return new Rectangle(x, y, width, height);
		}
		
		override public function getShapeDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var drawingAS3:String = "";
			
			if (!isNaN(topLeftRadiusX) || !isNaN(topRightRadiusX) ||
				!isNaN(bottomLeftRadiusX) || !isNaN(bottomRightRadiusX))
			{      
				drawingAS3 += getRoundRectComplexDrawingAS3(getInstanceName() + '.graphics', x, y, width, height, radiusX, radiusY,
					topLeftRadiusX, topLeftRadiusY, topRightRadiusX, topRightRadiusY, bottomLeftRadiusX, bottomLeftRadiusY, bottomRightRadiusX, bottomRightRadiusY);
			}
			else if (radiusX != 0)
			{
				var rX:Number = radiusX;
				var rY:Number =  radiusY == 0 ? radiusX : radiusY;
				drawingAS3 += '\n' + getInstanceName() + '.graphics.drawRoundRect(' + x + ', ' + y + ', ' + width + ', ' + height + ', ' + rX*2 + ', ' + rY*2 + ');';
			}
			else
			{
				drawingAS3 += '\n' + getInstanceName() + '.graphics.drawRect(' + x + ', ' + y + ', ' + width + ', ' + height + ');';
			}
			return drawingAS3;
		}
		
		// Pilfered from mx.utils:GraphicsUtil#drawRoundRectComplex2
		public static function getRoundRectComplexDrawingAS3(targetGraphicsIdentifier:String, x:Number, y:Number, 
													 width:Number, height:Number, 
													 radiusX:Number, radiusY:Number,
													 topLeftRadiusX:Number, topLeftRadiusY:Number,
													 topRightRadiusX:Number, topRightRadiusY:Number,
													 bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
													 bottomRightRadiusX:Number, bottomRightRadiusY:Number):String
		{
			var drawingCode:String = "";
			var xw:Number = x + width;
			var yh:Number = y + height;
			var maxXRadius:Number = width / 2;
			var maxYRadius:Number = height / 2;
			
			// Rules for determining radius for each corner:
			//  - If explicit nnnRadiusX value is set, use it. Otherwise use radiusX.
			//  - If explicit nnnRadiusY value is set, use it. Otherwise use corresponding nnnRadiusX.
			if (radiusY == 0)
				radiusY = radiusX;
			if (isNaN(topLeftRadiusX))
				topLeftRadiusX = radiusX;
			if (isNaN(topLeftRadiusY))
				topLeftRadiusY = topLeftRadiusX;
			if (isNaN(topRightRadiusX))
				topRightRadiusX = radiusX;
			if (isNaN(topRightRadiusY))
				topRightRadiusY = topRightRadiusX;
			if (isNaN(bottomLeftRadiusX))
				bottomLeftRadiusX = radiusX;
			if (isNaN(bottomLeftRadiusY))
				bottomLeftRadiusY = bottomLeftRadiusX;
			if (isNaN(bottomRightRadiusX))
				bottomRightRadiusX = radiusX;
			if (isNaN(bottomRightRadiusY))
				bottomRightRadiusY = bottomRightRadiusX;
			
			// Pin radius values to half of the width/height
			if (topLeftRadiusX > maxXRadius)
				topLeftRadiusX = maxXRadius;
			if (topLeftRadiusY > maxYRadius)
				topLeftRadiusY = maxYRadius;
			if (topRightRadiusX > maxXRadius)
				topRightRadiusX = maxXRadius;
			if (topRightRadiusY > maxYRadius)
				topRightRadiusY = maxYRadius;
			if (bottomLeftRadiusX > maxXRadius)
				bottomLeftRadiusX = maxXRadius;
			if (bottomLeftRadiusY > maxYRadius)
				bottomLeftRadiusY = maxYRadius;
			if (bottomRightRadiusX > maxXRadius)
				bottomRightRadiusX = maxXRadius;
			if (bottomRightRadiusY > maxYRadius)
				bottomRightRadiusY = maxYRadius;
			
			// Math.sin and Math,tan values for optimal performance.
			// Math.rad = Math.PI / 180 = 0.0174532925199433
			// r * Math.sin(45 * Math.rad) =  (r * 0.707106781186547);
			// r * Math.tan(22.5 * Math.rad) = (r * 0.414213562373095);
			//
			// We can save further cycles by precalculating
			// 1.0 - 0.707106781186547 = 0.292893218813453 and
			// 1.0 - 0.414213562373095 = 0.585786437626905
			
			// bottom-right corner
			var aX:Number = bottomRightRadiusX * 0.292893218813453;		// radius - anchor pt;
			var aY:Number = bottomRightRadiusY * 0.292893218813453;		// radius - anchor pt;
			var sX:Number = bottomRightRadiusX * 0.585786437626905; 	// radius - control pt;
			var sY:Number = bottomRightRadiusY * 0.585786437626905; 	// radius - control pt;
			drawingCode += '\n' + targetGraphicsIdentifier + '.moveTo(' + xw + ', ' + (yh - bottomRightRadiusY) + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + xw + ', ' + (yh - sY) + ', ' + (xw - aX) + ', ' + (yh - aY) + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + (xw - sX) + ', ' + yh + ', ' + (xw - bottomRightRadiusX) + ', ' + yh + ');';
			
			// bottom-left corner
			aX = bottomLeftRadiusX * 0.292893218813453;
			aY = bottomLeftRadiusY * 0.292893218813453;
			sX = bottomLeftRadiusX * 0.585786437626905;
			sY = bottomLeftRadiusY * 0.585786437626905;
			drawingCode += '\n' + targetGraphicsIdentifier + '.lineTo(' + (x + bottomLeftRadiusX) + ', ' + yh + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + (x + sX) + ', ' + yh + ', ' + (x + aX) + ', ' + (yh - aY) + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + x + ', ' + (yh - sY) + ', ' + x + ', ' + (yh - bottomLeftRadiusY) + ');';
			
			// top-left corner
			aX = topLeftRadiusX * 0.292893218813453;
			aY = topLeftRadiusY * 0.292893218813453;
			sX = topLeftRadiusX * 0.585786437626905;
			sY = topLeftRadiusY * 0.585786437626905;
			drawingCode += '\n' + targetGraphicsIdentifier + '.lineTo(' + x + ', ' + (y + topLeftRadiusY) + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + x + ', ' + (y + sY) + ', ' + (x + aX) + ', ' + (y + aY) + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + (x + sX) + ', ' + y + ', ' + (x + topLeftRadiusX) + ', ' + y + ');';
			
			// top-right corner
			aX = topRightRadiusX * 0.292893218813453;
			aY = topRightRadiusY * 0.292893218813453;
			sX = topRightRadiusX * 0.585786437626905;
			sY = topRightRadiusY * 0.585786437626905;
			drawingCode += '\n' + targetGraphicsIdentifier + '.lineTo(' + (xw - topRightRadiusX) + ', ' + y + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + (xw - sX) + ', ' + y + ', ' + (xw - aX) + ', ' + (y + aY) + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.curveTo(' + xw + ', ' + (y + sY) + ', ' + xw + ', ' + (y + topRightRadiusY) + ');';
			drawingCode += '\n' + targetGraphicsIdentifier + '.lineTo(' + xw + ', ' + (yh - bottomRightRadiusY) + ');';
			return drawingCode;
		}
	}
}