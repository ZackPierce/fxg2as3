package fxg2as3.graphics
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	import fxg2as3.NamingTracker;
	
	public class ExpressiveLinearGradientStrokeTest
	{		
		protected var library:Dictionary = new Dictionary(false);
		protected var namingTracker:NamingTracker = new NamingTracker();
		protected var gradientStroke:ExpressiveLinearGradientStroke;
		
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
			gradientStroke = new ExpressiveLinearGradientStroke();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
			gradientStroke = null;
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
		public function testExpressiveClone():void
		{
			Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testGetAS3String():void
		{
			Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testPopulateFromFXG():void
		{
			Assert.fail("Test method Not yet implemented");
		}
	}
}