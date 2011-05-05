package fxg2as3.displayObjects
{
	import flash.display.BlendMode;
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.NamingTracker;

	public class ExpressiveGroupTest
	{
		protected var library:Dictionary;
		protected var namingTracker:NamingTracker;
		protected var expressiveGroup:ExpressiveGroup;
		
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
			expressiveGroup = new ExpressiveGroup();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
			expressiveGroup = null;
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
		public function testParseAutoBlendModeWhenAlphaIsOne():void
		{
			var source:XML = <Group blendMode="auto" alpha="1"/>;
			expressiveGroup.parseBaseDisplayObjectAttributes(source);
			Assert.assertTrue("When a Group's blendMode is set to 'auto', it will be treated as 'normal' if the alpha is 1", expressiveGroup.blendMode == BlendMode.NORMAL); 
		}
		
		[Test]
		public function testParseAutoBlendModeWhenAlphaIsZero():void
		{
			var source:XML = <Group blendMode="auto" alpha="0"/>;
			expressiveGroup.parseBaseDisplayObjectAttributes(source);
			Assert.assertTrue("When a Group's blendMode is set to 'auto', it will be treated as 'normal' if the alpha is 0", expressiveGroup.blendMode == BlendMode.NORMAL); 
		}
		
		[Test]
		public function testParseAutoBlendModeWhenAlphaIsBetweenZeroAndOne():void
		{
			var source:XML = <Group blendMode="auto" alpha="0.5"/>;
			expressiveGroup.parseBaseDisplayObjectAttributes(source);
			Assert.assertTrue("When a Group's blendMode is set to 'auto', it will be treated as 'layer' if the alpha is more than 0 and less than 1", expressiveGroup.blendMode == BlendMode.LAYER); 
		}
		
		[Test]
		public function testClone():void
		{
			var copy:ExpressiveDisplayObject = expressiveGroup.clone(namingTracker);
			Assert.assertNotNull('clone produces object', copy);
			Assert.assertTrue('clone object a distinct instance from the original', copy != expressiveGroup);
			Assert.assertTrue('clone tracking id distinct from original tracking id', copy.trackingId != expressiveGroup.trackingId);
			Assert.assertTrue('clone produces object of the right type', copy is ExpressiveGroup);
		}
	}
}