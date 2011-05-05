package fxg2as3.displayObjects
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;
	
	public class ExpressiveEllipseShape extends ExpressiveShape
	{
		public var width:Number = 0;
		public var height:Number = 0;
		
		public function ExpressiveEllipseShape()
		{
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			parseEllipseProperties(fxgNode);
		}
		
		public function parseEllipseProperties(fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty('@width'))
			{
				width = Number(fxgNode.@width.toString());
			}
			if (fxgNode.hasOwnProperty('@height'))
			{
				height = Number(fxgNode.@height.toString());
			}
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshShape:ExpressiveEllipseShape = new ExpressiveEllipseShape();
			freshShape.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshShape, namingTracker);
			transferDuplicateShapeProperties(this, freshShape, namingTracker);
			transferDuplicateEllipseProperties(this, freshShape, namingTracker);
			return freshShape;
		}
		
		override public function getShapeBounds():Rectangle
		{
			return new Rectangle(x, y, width, height);
		}
		
		override public function getShapeDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return '\n' + getInstanceName() + '.graphics.drawEllipse(' + x + ', ' + y + ', ' + width + ', ' + height + ');';
		}
		
		public static function transferDuplicateEllipseProperties(source:ExpressiveEllipseShape, sink:ExpressiveEllipseShape, namingTracker:NamingTracker):void
		{
			sink.width = source.width;
			sink.height = source.height;
		}
	}
}