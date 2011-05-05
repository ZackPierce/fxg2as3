package fxg2as3.displayObjects
{
	import flash.display.BlendMode;
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.graphics.ExpressiveBitmapFill;
	import fxg2as3.graphics.ExpressiveLinearGradientFill;
	import fxg2as3.graphics.ExpressiveLinearGradientStroke;
	import fxg2as3.graphics.ExpressiveRadialGradientFill;
	import fxg2as3.graphics.ExpressiveRadialGradientStroke;
	import fxg2as3.graphics.ExpressiveSolidColorFill;
	import fxg2as3.graphics.ExpressiveSolidColorStroke;
	import fxg2as3.NamingTracker;
	
	import mx.graphics.LinearGradient;
	import mx.graphics.SolidColor;
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class ExpressiveShapeTest
	{	
		protected var library:Dictionary;
		protected var namingTracker:NamingTracker;
		protected var expressiveShape:ExpressiveShape;
		
		[Before]
		public function setUp():void
		{
			library = new Dictionary(false);
			namingTracker = new NamingTracker();
			expressiveShape = new ExpressiveShape();
		}
		
		[After]
		public function tearDown():void
		{
			library = null;
			namingTracker = null;
			expressiveShape = new ExpressiveShape();
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
		public function testParseBlendModeAutoResolvesToNormal():void
		{
			var source:XML = <Shape blendMode="auto"/>;
			expressiveShape.parseBaseDisplayObjectAttributes(source);
			Assert.assertTrue("shapes with FXG blendMode attributes set to 'auto' are recorded as 'normal'", expressiveShape.blendMode == BlendMode.NORMAL);
		}
		
		// Fill tests
		
		[Test]
		public function testParseFillResolvesNullIfNoFillSpecified():void
		{
			var source:XML = <Shape/>;
			expressiveShape.parseFill(source, namingTracker, library);
			Assert.assertNull('parseFill produces no fill object if no fill related xml provided', expressiveShape.fill);
		}
		
		[Test]
		public function testParseFillFindsAndGeneratesSolidColorFill():void
		{
			var source:XML = <Shape><fill><SolidColor/></fill></Shape>;
			expressiveShape.parseFill(source, namingTracker, library);
			Assert.assertNotNull('parseFill produces SolidColor fill object from appropriate xml', expressiveShape.fill);
			Assert.assertTrue('parseFill generates the right type of fill object for the SolidColor fill node', expressiveShape.fill is ExpressiveSolidColorFill);
		}
		
		[Test]
		public function testParseFillFindsAndGeneratesBitmapFill():void
		{
			var source:XML = <Shape><fill><BitmapFill/></fill></Shape>;
			expressiveShape.parseFill(source, namingTracker, library);
			Assert.assertNotNull('parseFill produces BitmapFill object from appropriate xml', expressiveShape.fill);
			Assert.assertTrue('parseFill generates the right type of fill object for the BitmapFill node', expressiveShape.fill is ExpressiveBitmapFill);
		}
		
		[Test]
		public function testParseFillFindsAndGeneratesLinearGradientFill():void
		{
			var source:XML = <Shape><fill><LinearGradient/></fill></Shape>;
			expressiveShape.parseFill(source, namingTracker, library);
			Assert.assertNotNull('parseFill produces LinearGradient object from appropriate xml', expressiveShape.fill);
			Assert.assertTrue('parseFill generates the right type of fill object for the LinearGradient fill node', expressiveShape.fill is ExpressiveLinearGradientFill);
		}
		
		[Test]
		public function testParseFillFindsAndGeneratesRadialGradientFill():void
		{
			var source:XML = <Shape><fill><RadialGradient/></fill></Shape>;
			expressiveShape.parseFill(source, namingTracker, library);
			Assert.assertNotNull('parseFill produces RadialGradient object from appropriate xml', expressiveShape.fill);
			Assert.assertTrue('parseFill generates the right type of fill object for the RadialGradient fill node', expressiveShape.fill is ExpressiveRadialGradientFill);
		}
		
		// Stroke tests
		
		[Test]
		public function testParseStrokeResolvesNullIfNoStrokeSpecified():void
		{
			var source:XML = <Shape/>;
			expressiveShape.parseStroke(source, namingTracker, library);
			Assert.assertNull('parseStroke produces no stroke object if no stroke related xml provided', expressiveShape.stroke);
		}
		
		[Test]
		public function testParseStrokeFindsAndGeneratesSolidColorStroke():void
		{
			var source:XML = <Shape><stroke><SolidColorStroke/></stroke></Shape>;
			expressiveShape.parseStroke(source, namingTracker, library);
			Assert.assertNotNull('parseStroke produces SolidColor stroke object from appropriate xml', expressiveShape.stroke);
			Assert.assertTrue('parseStroke generates the right type of stroke object for the SolidColor stroke node', expressiveShape.stroke is ExpressiveSolidColorStroke);
		}
		
		[Test]
		public function testParseStrokeFindsAndGeneratesLinearGradientStroke():void
		{
			var source:XML = <Shape><stroke><LinearGradientStroke/></stroke></Shape>;
			expressiveShape.parseStroke(source, namingTracker, library);
			Assert.assertNotNull('parseStroke produces LinearGradient object from appropriate xml', expressiveShape.stroke);
			Assert.assertTrue('parseStroke generates the right type of stroke object for the LinearGradient stroke node', expressiveShape.stroke is ExpressiveLinearGradientStroke);
		}
		
		[Test]
		public function testParseStrokeFindsAndGeneratesRadialGradientStroke():void
		{
			var source:XML = <Shape><stroke><RadialGradientStroke/></stroke></Shape>;
			expressiveShape.parseStroke(source, namingTracker, library);
			Assert.assertNotNull('parseStroke produces RadialGradient object from appropriate xml', expressiveShape.stroke);
			Assert.assertTrue('parseStroke generates the right type of stroke object for the RadialGradient stroke node', expressiveShape.stroke is ExpressiveRadialGradientStroke);
		}
		
		[Test]
		public function testClone():void
		{
			var copy:ExpressiveDisplayObject = expressiveShape.clone(namingTracker);
			Assert.assertNotNull('clone produces object', copy);
			Assert.assertTrue('clone object a distinct instance from the original', copy != expressiveShape);
			Assert.assertTrue('clone tracking id distinct from original tracking id', copy.trackingId != expressiveShape.trackingId);
			Assert.assertTrue('clone produces object of the right type', copy is ExpressiveShape);
		}
	}
}