package fxg2as3.graphics
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;
	
	public class ExpressiveSolidColorFillTest
	{	
		protected var library:Dictionary = new Dictionary(false);
		protected var namingTracker:NamingTracker = new NamingTracker();
		protected var solidColorFill:ExpressiveSolidColorFill;
		
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
			solidColorFill = new ExpressiveSolidColorFill();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
			solidColorFill = null;
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
			var copy:ExpressiveSolidColorFill = solidColorFill.expressiveClone(namingTracker) as ExpressiveSolidColorFill;
			Assert.assertNotNull('ExpressiveSolidColorFill.expressiveClone should never return null', copy);
			Assert.assertTrue('expressiveClone should be unique object instance', copy != solidColorFill);
		}
		
		[Test]
		public function testExpressiveSolidColorFill():void
		{
			Assert.assertTrue('Default color is 0x000000', solidColorFill.color == 0x000000);
			Assert.assertTrue('Default alpha is 1.0', solidColorFill.alpha == 1.0);
		}
		
		[Test]
		public function testGetBeginningAS3String():void
		{
			Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testGetEndingAS3String():void
		{
			Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testPopulateFromFXG():void
		{
			var testColor:uint = 0x00FF00;
			var testAlpha:Number = 0.5;
			solidColorFill.populateFromFXG(<SolidColor color={FXGConverter.convertColorUintToHexString(testColor)} alpha={testAlpha} />, namingTracker, library);
			Assert.assertTrue('parsed color matches source xml color attribute', solidColorFill.color == testColor);
			Assert.assertTrue('parsed alpha matches source xml alpha attribute', solidColorFill.alpha == testAlpha);
		}
	}
}