package fxg2as3.displayObjects
{
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;
	import fxg2as3.graphics.ExpressiveBitmapFill;
	import fxg2as3.graphics.ExpressiveLinearGradientFill;
	import fxg2as3.graphics.ExpressiveLinearGradientStroke;
	import fxg2as3.graphics.ExpressiveRadialGradientFill;
	import fxg2as3.graphics.ExpressiveRadialGradientStroke;
	import fxg2as3.graphics.ExpressiveSolidColorFill;
	import fxg2as3.graphics.ExpressiveSolidColorStroke;
	import fxg2as3.graphics.IExpressiveFill;
	import fxg2as3.graphics.IExpressiveStroke;

	public class ExpressiveShape extends ExpressiveDisplayObject
	{
		public var fill:IExpressiveFill;
		public var stroke:IExpressiveStroke;
		
		private var supportedFillClassNames:Array = ["BitmapFill", "LinearGradient", "RadialGradient", "SolidColor"];
		private var supportedStrokeClassNames:Array = ["LinearGradientStroke", "RadialGradientStroke", "SolidColorStroke"];
		
		public function ExpressiveShape()
		{
			super();
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			parseFill(fxgNode, namingTracker, library);
			parseStroke(fxgNode, namingTracker, library);
		}
		
		public function parseFill(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			var foundFillContainers:XMLList = fxgNode.*::fill;
			if (foundFillContainers.length() < 1)
			{
				return;
			}
			var fillNodes:XMLList = (foundFillContainers[0] as XML).children();
			for each (var node:XML in fillNodes)
			{
				var nodeName:String = node.localName() ? node.localName().toString() : null;
				if (!nodeName || nodeName == null || supportedFillClassNames.indexOf(nodeName) < 0)
				{
					continue;
				}
				var expressiveFill:IExpressiveFill = null;
				switch(nodeName)
				{
					case "BitmapFill":
						expressiveFill = new ExpressiveBitmapFill();
						break;
					case "LinearGradient":
						expressiveFill = new ExpressiveLinearGradientFill();
						break;
					case "RadialGradient":
						expressiveFill = new ExpressiveRadialGradientFill();
						break;
					case "SolidColor":
						expressiveFill = new ExpressiveSolidColorFill();
						break;
				}
				if (expressiveFill)
				{
					expressiveFill.populateFromFXG(node, namingTracker, library);
					fill = expressiveFill;
				}
			}
		}
		
		public function parseStroke(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			var foundStrokeContainers:XMLList = fxgNode.*::stroke;
			if (foundStrokeContainers.length() < 1)
			{
				return;
			}
			var strokeNodes:XMLList = (foundStrokeContainers[0] as XML).children();
			for each (var node:XML in strokeNodes)
			{
				var nodeName:String = node.localName() ? node.localName().toString() : null;
				if (!nodeName || nodeName == null || supportedStrokeClassNames.indexOf(nodeName) < 0)
				{
					continue;
				}
				var expressiveStroke:IExpressiveStroke = null;
				switch(nodeName)
				{
					case "LinearGradientStroke":
						expressiveStroke = new ExpressiveLinearGradientStroke();
						break;
					case "RadialGradientStroke":
						expressiveStroke = new ExpressiveRadialGradientStroke();
						break;
					case "SolidColorStroke":
						expressiveStroke = new ExpressiveSolidColorStroke();
						break;
				}
				if (expressiveStroke)
				{
					expressiveStroke.populateFromFXG(node, namingTracker, library);
					stroke = expressiveStroke;
				}
			}
		}
		
		override public function parseBaseDisplayObjectAttributes(fxgNode:XML):void
		{
			super.parseBaseDisplayObjectAttributes(fxgNode);
			if (this.blendMode == "auto")
			{
				this.blendMode = BlendMode.NORMAL;
			}
		}
		
		override public function getInstanceName():String
		{
			return explicitId ? explicitId : "shape" + trackingId;
		}
		
		override public function getInstantiationAS3(targetFlex3:Boolean):String
		{
			return '\nvar ' + getInstanceName() + ':Shape = new Shape();';
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshShape:ExpressiveShape = new ExpressiveShape();
			freshShape.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshShape, namingTracker);
			transferDuplicateShapeProperties(this, freshShape, namingTracker);
			return freshShape;
		}
		
		public static function transferDuplicateShapeProperties(source:ExpressiveShape, sink:ExpressiveShape, namingTracker:NamingTracker):void
		{
			sink.fill = source.fill ? source.fill.expressiveClone(namingTracker) : null;
			sink.stroke = source.stroke ? source.stroke.expressiveClone(namingTracker) : null;
		}
		
		public function getShapeBounds():Rectangle
		{
			return null; // Meaningfully overridden in children
		}
		
		override public function getDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var drawingCode:String = "";
			drawingCode += getStrokeAS3();
			drawingCode += getFillBeginningAS3(targetFlex3);
			drawingCode += getShapeDrawingAS3(targetFlex3, useVectorNotation, numericPrintingPrecision);
			drawingCode += getFillEndingAS3();
			return drawingCode;
		}
		
		public function getShapeDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return ""; // Meaningfully overridden in children
		}
		
		public function getFillBeginningAS3(targetFlex3:Boolean):String
		{
			return fill ? fill.getBeginningAS3String(this.getInstanceName() + ".graphics", this.getShapeBounds(), targetFlex3) : "";
		}
		
		public function getFillEndingAS3():String
		{
			return fill ? fill.getEndingAS3String(this.getInstanceName() + ".graphics") : "";
		}
		
		public function getStrokeAS3():String
		{
			return stroke ? stroke.getAS3String(this.getInstanceName() + ".graphics", this.getShapeBounds()) : "";
		}
	}
}