package fxg2as3.graphics
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import flexunit.framework.Assert;
	
	import mx.graphics.SolidColorStroke;
	
	public class ExpressiveStrokeUtilTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
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
		public function testParseStrokePropertiesFromFXG():void
		{
			var testWeight:Number = 2;
			var testPixelHinting:Boolean = true;
			var testScaleMode:String = LineScaleMode.HORIZONTAL;
			var testJoints:String = JointStyle.BEVEL;
			var testCaps:String = CapsStyle.SQUARE;
			var testMiterLimit:Number = 6.022;
			var source:XML = <SolidColorStroke  weight={testWeight}
				scaleMode={testScaleMode} joints={testJoints} caps={testCaps}
				miterLimit={testMiterLimit} pixelHinting={testPixelHinting} />;
			var solidColorStroke:ExpressiveSolidColorStroke = new ExpressiveSolidColorStroke();
			ExpressiveStrokeUtil.parseStrokePropertiesFromFXG(solidColorStroke, source);
			
			Assert.assertTrue('Parsed weight matches source xml value', solidColorStroke.weight == testWeight);
			Assert.assertTrue('Parsed pixelHinting matches source xml value', solidColorStroke.pixelHinting == testPixelHinting);
			Assert.assertTrue('Parsed scaleMode matches source xml value', solidColorStroke.scaleMode == testScaleMode);
			Assert.assertTrue('Parsed joints matches source xml value', solidColorStroke.joints == testJoints);
			Assert.assertTrue('Parsed caps matches source xml value', solidColorStroke.caps == testCaps);
			Assert.assertTrue('Parsed miterLimit matches source xml value', solidColorStroke.miterLimit == testMiterLimit);		}
	}
}