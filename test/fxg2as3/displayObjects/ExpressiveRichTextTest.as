package fxg2as3.displayObjects
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.NamingTracker;
	
	public class ExpressiveRichTextTest
	{
		protected var library:Dictionary;
		protected var namingTracker:NamingTracker;
		protected var expressiveText:ExpressiveRichText;
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
			expressiveText = new ExpressiveRichText();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
			expressiveText = null;
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
		public function testPopulateFromFXG():void
		{
			Assert.fail("Test method Not yet implemented");
		}
	}
}