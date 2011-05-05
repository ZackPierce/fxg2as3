package fxg2as3.displayObjects
{
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.NamingTracker;
	
	public class ExpressivePathShapeTest
	{		
		protected var library:Dictionary;
		protected var namingTracker:NamingTracker;
		protected var expressivePath:ExpressivePathShape;
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
			expressivePath = new ExpressivePathShape();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
			expressivePath = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testClone():void
		{
			var copy:ExpressiveDisplayObject = expressivePath.clone(namingTracker);
			Assert.assertNotNull('clone produces object', copy);
			Assert.assertTrue('clone object a distinct instance from the original', copy != expressivePath);
			Assert.assertTrue('clone tracking id distinct from original tracking id', copy.trackingId != expressivePath.trackingId);
			Assert.assertTrue('clone produces object of the right type', copy is ExpressivePathShape);
		}
		
		[Test]
		public function testParsePathProperties():void
		{
			var testWinding:String = "nonZero";
			var testData:String = 'M 1 2 L 3 4 Q 5 6 7 8';
			var source:XML = <Path winding={testWinding} data={testData}/>;
			expressivePath.parsePathProperties(source);
			Assert.assertTrue('Parsed winding matches source xml value', expressivePath.winding == testWinding);
			Assert.assertTrue('Parses  moveTo instruction', expressivePath.graphicsPath.commands[0] == GraphicsPathCommand.MOVE_TO);
			Assert.assertTrue('Parses lineTo instruction', expressivePath.graphicsPath.commands[1] == GraphicsPathCommand.LINE_TO);
			Assert.assertTrue('Parses quadratic curveTo instruction', expressivePath.graphicsPath.commands[2] == GraphicsPathCommand.CURVE_TO);
			Assert.assertTrue('Parses absolute instructions x positional data for moveTo', expressivePath.graphicsPath.data[0] == 1);
			Assert.assertTrue('Parses absolute instructions y positional data for moveTo', expressivePath.graphicsPath.data[1] == 2);
			Assert.assertTrue('Parses absolute instructions x positional data for lineTo', expressivePath.graphicsPath.data[2] == 3);
			Assert.assertTrue('Parses absolute instructions y positional data for lineTo', expressivePath.graphicsPath.data[3] == 4);
			Assert.assertTrue('Parses absolute instructions control x positional data for curveTo', expressivePath.graphicsPath.data[4] == 5);
			Assert.assertTrue('Parses absolute instructions control y positional data for curveTo', expressivePath.graphicsPath.data[5] == 6);
			Assert.assertTrue('Parses absolute instructions end x positional data for curveTo', expressivePath.graphicsPath.data[6] == 7);
			Assert.assertTrue('Parses absolute instructions end y positional data for curveTo', expressivePath.graphicsPath.data[7] == 8);
		}
		
		[Test]
		public function testTransferDuplicatePathShapeProperties():void
		{
			expressivePath.winding = "nonZero";
			var testCommands:Vector.<int> = Vector.<int>([GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.CURVE_TO]);
			var testData:Vector.<Number> = Vector.<Number>([0,1,2,3,4,5,6,7]);
			expressivePath.graphicsPath = new GraphicsPath(testCommands, testData);
			var sink:ExpressivePathShape = new ExpressivePathShape();
			ExpressivePathShape.transferDuplicatePathShapeProperties(expressivePath, sink);
			Assert.assertTrue('Sink winding matches source value', expressivePath.winding == sink.winding);
			Assert.assertTrue('Sink has same number of commands as source', expressivePath.graphicsPath.commands.length == sink.graphicsPath.commands.length);
			Assert.assertTrue('Sink has same number of positional data as source', expressivePath.graphicsPath.data.length == sink.graphicsPath.data.length);
			for (var i:int = 0; i < expressivePath.graphicsPath.commands.length; i++)
			{
				Assert.assertTrue('Sink command matches source command at index ' + i, expressivePath.graphicsPath.commands[i] == sink.graphicsPath.commands[i]);
			}
			for (var j:int = 0; j < expressivePath.graphicsPath.data.length; j++)
			{
				Assert.assertTrue('Sink data matches source data at index ' + j, expressivePath.graphicsPath.data[j] == sink.graphicsPath.data[j]);
			}
		}
		
		[Test]
		public function testGetDrawingAS3():void
		{
			Assert.fail("Test method Not yet implemented");
		}
	}
}