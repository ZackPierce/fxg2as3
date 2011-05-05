package fxg2as3.graphics
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;
	
	public class ExpressiveSolidColorStrokeTest
	{		
		protected var library:Dictionary = new Dictionary(false);
		protected var namingTracker:NamingTracker = new NamingTracker();
		protected var solidColorStroke:ExpressiveSolidColorStroke;
		
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
			solidColorStroke = new ExpressiveSolidColorStroke();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
			solidColorStroke = null;
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
			var testColor:uint = 0xFF00FF;
			var testWeight:Number = 2;
			var testAlpha:Number = 0.5;
			var testPixelHinting:Boolean = true;
			var testScaleMode:String = LineScaleMode.HORIZONTAL;
			var testJoints:String = JointStyle.BEVEL;
			var testCaps:String = CapsStyle.SQUARE;
			var testMiterLimit:Number = 6.022;
			solidColorStroke.color = testColor;
			solidColorStroke.weight = testWeight;
			solidColorStroke.alpha = testAlpha;
			solidColorStroke.pixelHinting = testPixelHinting;
			solidColorStroke.scaleMode = testScaleMode;
			solidColorStroke.joints = testJoints;
			solidColorStroke.miterLimit = testMiterLimit;
			
			var copy:IExpressiveStroke = solidColorStroke.expressiveClone(namingTracker);
			Assert.assertTrue('Expressive clone creates the right subclass', copy is ExpressiveSolidColorStroke);
			var castCopy:ExpressiveSolidColorStroke = copy as ExpressiveSolidColorStroke;
			Assert.assertTrue('Copied color matches source value', solidColorStroke.color == castCopy.color);
			Assert.assertTrue('Copied weight matches source value', solidColorStroke.weight == castCopy.weight);
			Assert.assertTrue('Copied alpha matches source value', solidColorStroke.alpha == castCopy.alpha);
			Assert.assertTrue('Copied pixelHinting matches source value', solidColorStroke.pixelHinting == castCopy.pixelHinting);
			Assert.assertTrue('Copied scaleMode matches source value', solidColorStroke.scaleMode == castCopy.scaleMode);
			Assert.assertTrue('Copied joints matches source value', solidColorStroke.joints == castCopy.joints);
			Assert.assertTrue('Copied caps matches source value', solidColorStroke.caps == castCopy.caps);
			Assert.assertTrue('Copied miterLimit matches source value', solidColorStroke.miterLimit == castCopy.miterLimit);
		}
		
		[Test]
		public function testExpressiveSolidColorStroke():void
		{
			Assert.assertTrue('Default color is 0x000000', solidColorStroke.color == 0x000000);
			Assert.assertTrue('Default weight is 1', solidColorStroke.weight == 1);
			Assert.assertTrue('Default alpha is 1', solidColorStroke.alpha == 1);
			Assert.assertTrue('Default pixelHinting is false', solidColorStroke.pixelHinting == false);
			Assert.assertTrue('Default scaleMode is normal', solidColorStroke.scaleMode == LineScaleMode.NORMAL);
			Assert.assertTrue('Default joints value is round', solidColorStroke.joints == JointStyle.ROUND);
			Assert.assertTrue('Default caps value is round', solidColorStroke.caps == CapsStyle.ROUND);
			Assert.assertTrue('Default miterLimit value is 3', solidColorStroke.miterLimit == 3);
		}
		
		[Test]
		public function testGetAS3String():void
		{
			Assert.fail("Test method Not yet implemented");
		}
		
		[Test]
		public function testPopulateFromFXG():void
		{
			var testColor:uint = 0xFF00FF;
			var testWeight:Number = 2;
			var testAlpha:Number = 0.5;
			var testPixelHinting:Boolean = true;
			var testScaleMode:String = LineScaleMode.HORIZONTAL;
			var testJoints:String = JointStyle.BEVEL;
			var testCaps:String = CapsStyle.SQUARE;
			var testMiterLimit:Number = 6.022;
			var source:XML = <SolidColorStroke color={FXGConverter.convertColorUintToHexString(testColor)} 
							weight={testWeight} alpha={testAlpha} pixelHinting={testPixelHinting}
							scaleMode={testScaleMode} joints={testJoints} caps={testCaps}
							miterLimit={testMiterLimit}/>;
			solidColorStroke.populateFromFXG(source, namingTracker, library);
			
			Assert.assertTrue('Parsed color matches source xml value', solidColorStroke.color == testColor);
			Assert.assertTrue('Parsed weight matches source xml value', solidColorStroke.weight == testWeight);
			Assert.assertTrue('Parsed alpha matches source xml value', solidColorStroke.alpha == testAlpha);
			Assert.assertTrue('Parsed pixelHinting matches source xml value', solidColorStroke.pixelHinting == testPixelHinting);
			Assert.assertTrue('Parsed scaleMode matches source xml value', solidColorStroke.scaleMode == testScaleMode);
			Assert.assertTrue('Parsed joints matches source xml value', solidColorStroke.joints == testJoints);
			Assert.assertTrue('Parsed caps matches source xml value', solidColorStroke.caps == testCaps);
			Assert.assertTrue('Parsed miterLimit matches source xml value', solidColorStroke.miterLimit == testMiterLimit);
		}
	}
}