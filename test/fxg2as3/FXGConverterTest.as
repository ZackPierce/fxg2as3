package fxg2as3
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.displayObjects.ExpressiveBitmapImage;
	import fxg2as3.displayObjects.ExpressiveEllipseShape;
	import fxg2as3.displayObjects.ExpressiveGraphic;
	import fxg2as3.displayObjects.ExpressiveGroup;
	import fxg2as3.displayObjects.ExpressiveLineShape;
	import fxg2as3.displayObjects.ExpressivePathShape;
	import fxg2as3.displayObjects.ExpressiveRectShape;
	import fxg2as3.displayObjects.ExpressiveRichText;
	
	public class FXGConverterTest
	{		
		protected var library:Dictionary;
		protected var namingTracker:NamingTracker;
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
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
		public function testConvertColorUintToHexString():void
		{
			Assert.assertTrue('0xFFFFFF converts to "0xFFFFFF"', FXGConverter.convertColorUintToHexString(0xFFFFFF) == '0xFFFFFF');
			Assert.assertTrue('0x000000 converts to "0x000000"', FXGConverter.convertColorUintToHexString(0x000000) == '0x000000');
			Assert.assertTrue('0x00FF00 converts to "0x00FF00"', FXGConverter.convertColorUintToHexString(0x00FF00) == '0x00FF00');
			Assert.assertTrue('0x000008 converts to "0x000008"', FXGConverter.convertColorUintToHexString(0x000008) == '0x000008');
		}
		
		[Test]
		public function testGenerateAS3FromFXGNode():void
		{
			Assert.fail("Test method Not yet implemented");
		}
		
				
		[Test]
		public function testParseColorHashStringToUint():void
		{
			Assert.assertTrue('#FFFFFF converts to 0xFFFFFF', FXGConverter.parseColorHashStringToUint('#FFFFFF') == 0xFFFFFF);
			Assert.assertTrue('#000000 converts to 0x000000', FXGConverter.parseColorHashStringToUint('#000000') == 0x000000);
			Assert.assertTrue('#00FF00 converts to 0x00FF00', FXGConverter.parseColorHashStringToUint('#00FF00') == 0x00FF00);
			Assert.assertTrue('#000008 converts to 0x000008', FXGConverter.parseColorHashStringToUint('#000008') == 0x000008);
		}
	}
}