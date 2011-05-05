package fxg2as3.displayObjects
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;

	public class ExpressiveLineShape extends ExpressiveShape
	{
		public var xFrom:Number = 0;
		public var yFrom:Number = 0;
		public var xTo:Number = 0;
		public var yTo:Number = 0;
		
		
		public function ExpressiveLineShape()
		{
			super();
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			parseLineProperties(fxgNode);
		}
		
		public function parseLineProperties(fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty('@xFrom'))
			{
				xFrom = Number(fxgNode.@xFrom.toString());
			}
			if (fxgNode.hasOwnProperty('@yFrom'))
			{
				yFrom = Number(fxgNode.@yFrom.toString());
			}
			if (fxgNode.hasOwnProperty('@xTo'))
			{
				xTo = Number(fxgNode.@xTo.toString());
			}
			if (fxgNode.hasOwnProperty('@yTo'))
			{
				yTo = Number(fxgNode.@yTo.toString());
			}
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshShape:ExpressiveLineShape = new ExpressiveLineShape();
			freshShape.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshShape, namingTracker);
			transferDuplicateShapeProperties(this, freshShape, namingTracker);
			transferDuplicateLineShapeProperties(this, freshShape, namingTracker);
			return freshShape;
		}
		
		public static function transferDuplicateLineShapeProperties(source:ExpressiveLineShape, sink:ExpressiveLineShape, namingTracker:NamingTracker):void
		{
			sink.xFrom = source.xFrom;
			sink.yFrom = source.yFrom;
			sink.xTo = source.xTo;
			sink.yTo = source.yTo;
		}
		
		override public function getShapeBounds():Rectangle
		{
			return new Rectangle(Math.min(xFrom, xTo), Math.min(yFrom, yTo), Math.abs(xFrom - xTo), Math.abs(yFrom - yTo));
		}
		
		override public function getShapeDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var drawingCode:String = '';
			drawingCode += '\n' + this.getInstanceName() + '.graphics.moveTo(' + xFrom + ', ' + yFrom + ');';
			drawingCode += '\n' + this.getInstanceName() + '.graphics.lineTo(' + xTo + ', ' + yTo + ');';
			return drawingCode;
		}
	}
}