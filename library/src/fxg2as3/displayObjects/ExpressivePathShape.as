package fxg2as3.displayObjects
{
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;
	
	import spark.primitives.supportClasses.PathSegmentsCollection;

	public class ExpressivePathShape extends ExpressiveShape
	{
		public var graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
		public var winding:String = "evenOdd";
		
		public function ExpressivePathShape()
		{
			super();
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			parsePathProperties(fxgNode);
		}
		
		public function parsePathProperties(fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty('@winding'))
			{
				winding = fxgNode.@winding.toString();
			}
			if (fxgNode.hasOwnProperty('@data'))
			{
				graphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>(), winding);
				var segments:PathSegmentsCollection = new PathSegmentsCollection(fxgNode.@data.toString());
				segments.generateGraphicsPath(graphicsPath, 0, 0, 1, 1);
				// Prune unnecessary move to 0,0 if the second command is another move
				if (graphicsPath.commands.length > 1 && graphicsPath.commands[0] == GraphicsPathCommand.MOVE_TO && graphicsPath.commands[1] == GraphicsPathCommand.MOVE_TO)
				{
					graphicsPath.commands.shift();
					graphicsPath.data.shift();
					graphicsPath.data.shift();
				}
			}
		}
		
		override public function getShapeBounds():Rectangle
		{
			var smallestX:Number = Number.MAX_VALUE;
			var smallestY:Number = Number.MAX_VALUE;
			var largestX:Number = Number.MIN_VALUE;
			var largestY:Number = Number.MIN_VALUE;
			if (!graphicsPath || !graphicsPath.data || graphicsPath.data.length == 0) {
				return new Rectangle();
			}
			var data:Vector.<Number> = graphicsPath.data;
			var datum:Number;
			var stop:int = data.length;
			// Naive min/max of x and y type values - TBD - replace with better handling for curve-to control points
			for (var i:int = 0; i < stop; i++)
			{
				datum = data[i];
				if (i%2 == 0)
				{
					if (datum < smallestX)
					{
						smallestX = datum;
					}
					if (datum > largestX)
					{
						largestX = datum;
					}
				}
				else 
				{
					if (datum < smallestY)
					{
						smallestY = datum;
					}
					if (datum > largestY)
					{
						largestY = datum;
					}
				}
			}
			return new Rectangle(smallestX, smallestY, largestX - smallestX, largestY - smallestY);
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshShape:ExpressivePathShape = new ExpressivePathShape();
			freshShape.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshShape, namingTracker);
			transferDuplicateShapeProperties(this, freshShape, namingTracker);
			transferDuplicatePathShapeProperties(this, freshShape);
			return freshShape;
		}
		
		override public function getShapeDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var drawingCode:String = '';
			var commands:Vector.<int> = graphicsPath.commands;
			var data:Vector.<Number> = graphicsPath.data;
			if (useVectorNotation)
			{
				drawingCode += '\n' + getInstanceName() + '.graphics.drawPath( Vector.<int>([' + commands.toString() +']),\n        Vector.<Number>([' + numericVectorToPrecisionStringsAS3(data, numericPrintingPrecision) + '])' + ', "' + winding + '");';
			}
			else 
			{
				var dataIndex:int = 0;
				var numCommands:int = commands.length;
				for (var i:int = 0; i < numCommands; i++)
				{
					var currCommand:int = commands[i];
					switch(currCommand)
					{
						case GraphicsPathCommand.MOVE_TO:
							drawingCode += '\n' + getInstanceName() + '.graphics.moveTo(' + data[dataIndex].toPrecision(numericPrintingPrecision) + ', ' + data[dataIndex + 1].toPrecision(numericPrintingPrecision) + ');';
							dataIndex += 2;
							break;
						case GraphicsPathCommand.LINE_TO:
							drawingCode += '\n' + getInstanceName() + '.graphics.lineTo(' + data[dataIndex].toPrecision(numericPrintingPrecision) + ', ' + data[dataIndex + 1].toPrecision(numericPrintingPrecision) + ');';
							dataIndex += 2;
							break;
						case GraphicsPathCommand.CURVE_TO:
							drawingCode += '\n' + getInstanceName() + '.graphics.curveTo(' + data[dataIndex].toPrecision(numericPrintingPrecision) + ', ' + data[dataIndex + 1].toPrecision(numericPrintingPrecision) + ', ' + data[dataIndex + 2].toPrecision(numericPrintingPrecision) + ', ' + data[dataIndex + 3].toPrecision(numericPrintingPrecision) + ');';
							dataIndex += 4;
							break;
					}
				}
			}
			
			return drawingCode;
		}
		
		private static function numericVectorToPrecisionStringsAS3(target:Vector.<Number>, numericPrintingPrecision:int):String
		{
			if (!target)
			{
				return '';
			}
			var preciseValues:Vector.<String> = new Vector.<String>();
			for (var i:int = 0; i < target.length; i++)
			{
				preciseValues.push(target[i].toPrecision(numericPrintingPrecision));
			}
			return preciseValues.join(',');
		}
		
		public static function transferDuplicatePathShapeProperties(source:ExpressivePathShape, sink:ExpressivePathShape):void
		{
			sink.winding = source.winding;
			sink.graphicsPath = new GraphicsPath(source.graphicsPath.commands.concat(), source.graphicsPath.data.concat());
		}
	}
}