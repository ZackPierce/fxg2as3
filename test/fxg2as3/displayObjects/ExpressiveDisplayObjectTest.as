package fxg2as3.displayObjects
{
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.NamingTracker;
	import fxg2as3.filters.ExpressiveBevelFilter;
	import fxg2as3.filters.ExpressiveBlurFilter;
	import fxg2as3.filters.ExpressiveColorMatrixFilter;
	import fxg2as3.filters.ExpressiveDropShadowFilter;
	import fxg2as3.filters.ExpressiveGlowFilter;
	import fxg2as3.filters.ExpressiveGradientBevelFilter;
	import fxg2as3.filters.ExpressiveGradientGlowFilter;
	import fxg2as3.filters.IExpressiveFilter;
	
	import spark.core.MaskType;
	
	public class ExpressiveDisplayObjectTest
	{
		protected var noAttributesDisplayObjectSource:XML;
		protected var namingTracker:NamingTracker;
		protected var library:Dictionary = new Dictionary(false);
		protected var displayObject:ExpressiveDisplayObject;
		
		[Before]
		public function setUp():void
		{
			noAttributesDisplayObjectSource = <DisplayObject/>;
			namingTracker = new NamingTracker();
			displayObject = new ExpressiveDisplayObject();
		}
		
		[After]
		public function tearDown():void
		{
			noAttributesDisplayObjectSource = null;
			namingTracker = null;
			displayObject = null;
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
		public function testPopulateFromFXGNoAttributesPreserveDefaultProperties():void
		{
			var genericObject:ExpressiveDisplayObject = new ExpressiveDisplayObject();
			genericObject.populateFromFXG(noAttributesDisplayObjectSource, null, null);
			Assert.assertNull("explicit id defaults to null", genericObject.explicitId);
			Assert.assertTrue("x defaults to 0", genericObject.x == 0);
			Assert.assertTrue("y defaults to 0", genericObject.y == 0);
			Assert.assertTrue("scaleX defaults to 1", genericObject.scaleX == 1);
			Assert.assertTrue("scaleY defaults to 1", genericObject.scaleY == 1);
			Assert.assertTrue("rotation defaults to 0", genericObject.rotation == 0);
			Assert.assertTrue("alpha defaults to 1", genericObject.alpha == 1);
			Assert.assertTrue("visible defaults to true", genericObject.visible);
			Assert.assertTrue("blend mode defaults to normal", genericObject.blendMode == BlendMode.NORMAL);
			Assert.assertTrue("maskType defaults to 'clip'", genericObject.maskType == MaskType.CLIP);
		}
		
		[Test]
		public function testParseBaseDisplayObjectAttributes():void
		{
			var genericObject:ExpressiveDisplayObject = new ExpressiveDisplayObject();
			var customId:String = "hello";
			var customX:Number = 1;
			var customY:Number = 2;
			var customScaleX:Number = 3;
			var customScaleY:Number = 4;
			var customRotation:Number = 42;
			var customAlpha:Number = 0.5;
			var customVisible:Boolean = false;
			var customBlendMode:String = BlendMode.DARKEN;
			var customMaskType:String = MaskType.LUMINOSITY;
			var source:XML = <DisplayObject id={customId} x={customX} y={customY} scaleX={customScaleX} scaleY={customScaleY} rotation={customRotation} alpha={customAlpha} visible={customVisible} blendMode={customBlendMode} maskType={customMaskType} />;
			genericObject.parseBaseDisplayObjectAttributes(source);
			Assert.assertTrue("parsed explicit id matches source id attribute", genericObject.explicitId == customId);
			Assert.assertTrue("parsed x matches source x attribute", genericObject.x == customX);
			Assert.assertTrue("parsed y matches source y attribute", genericObject.y == customY);
			Assert.assertTrue("parsed scaleX matches source scaleX attribute", genericObject.scaleX == customScaleX);
			Assert.assertTrue("parsed scaleY matches source scaleY attribute", genericObject.scaleY == customScaleY);
			Assert.assertTrue("parsed rotation matches source rotation attribute", genericObject.rotation == customRotation);
			Assert.assertTrue("parsed alpha matches source alpha attribute", genericObject.alpha == customAlpha);
			Assert.assertTrue("parsed visible matches source visible attribute", genericObject.visible == customVisible);
			Assert.assertTrue("parsed blendMode matches source blendMode attribute", genericObject.blendMode == customBlendMode);
			Assert.assertTrue("parsed maskType matches source maskType attribute", genericObject.maskType == customMaskType);
			
		}
		
		[Test]
		public function testTransferDuplicateProperties():void
		{
			var original:ExpressiveDisplayObject = new ExpressiveDisplayObject();
			original.explicitId = "hello";
			original.x = 1;
			original.y = 2;
			original.scaleX = 3;
			original.scaleY = 4;
			original.alpha = 0.5;
			original.visible = false;
			original.blendMode = BlendMode.DARKEN;
			original.scale9Grid = new Rectangle(3, 1, 4, 1);
			var mask:ExpressiveDisplayObject = new ExpressiveDisplayObject();
			mask.explicitId = "maskyMcMaskerson";
			original.mask = mask;
			original.filters = new Vector.<IExpressiveFilter>();
			original.filters.push(new ExpressiveBlurFilter(3.14159));
			var sink:ExpressiveDisplayObject = new ExpressiveDisplayObject();
			ExpressiveDisplayObject.transferDuplicateDisplayObjectProperties(original, sink, new NamingTracker());
			Assert.assertTrue("sink explicit id matches original id attribute", original.explicitId == sink.explicitId);
			Assert.assertTrue("sink x matches original x attribute", original.x == sink.x);
			Assert.assertTrue("sink y matches original y attribute", original.y == sink.y);
			Assert.assertTrue("sink scaleX matches original scaleX attribute", original.scaleX == sink.scaleX);
			Assert.assertTrue("sink scaleY matches original scaleY attribute", original.scaleY == sink.scaleY);
			Assert.assertTrue("sink alpha matches original alpha attribute", original.alpha == sink.alpha);
			Assert.assertTrue("sink visible matches original visible attribute", original.visible == sink.visible);
			Assert.assertTrue("sink blendMode matches original blendMode attribute", original.blendMode == sink.blendMode);
			Assert.assertTrue("sink scale9Grid x matches original scale9Grid", original.scale9Grid.x == sink.scale9Grid.x);
			Assert.assertTrue("sink scale9Grid y matches original scale9Grid", original.scale9Grid.y == sink.scale9Grid.y);
			Assert.assertTrue("sink scale9Grid width matches original scale9Grid", original.scale9Grid.width == sink.scale9Grid.width);
			Assert.assertTrue("sink scale9Grid height matches original scale9Grid", original.scale9Grid.height == sink.scale9Grid.height);
			Assert.assertTrue("sink mask properties should match original mask properties", original.mask.explicitId == sink.mask.explicitId);
			Assert.assertTrue("sink mask should be a different object than the original mask when the mask is non-null", original.mask != sink.mask);
			Assert.assertTrue("sink should have the same number of filters as the original", original.filters.length == sink.filters.length);
		}
		
		// TBD - Move tests to separate class
//		[Test]
//		public function testParseMatrixInstantiatesMatrixObject():void
//		{
//			var fxgNode:XML = <DisplayObject><transform><Transform><matrix><Matrix/></matrix></Transform></transform></DisplayObject>;
//			var displayObject:ExpressiveDisplayObject = new ExpressiveDisplayObject();
//			displayObject.parseMatrix(fxgNode, namingTracker, library);
//			Assert.assertNotNull("parse matrix should instantiate an expressive matrix if the fxg node contains a matrix", displayObject.matrix);
//		}
//		
//		[Test]
//		public function testParseMatrixDoesntInstantiateMatrixIfNoMatrixChildExistsInSourceXML():void
//		{
//			var fxgNode:XML = <DisplayObject></DisplayObject>;
//			var displayObject:ExpressiveDisplayObject = new ExpressiveDisplayObject();
//			displayObject.parseMatrix(fxgNode, namingTracker, library);
//			Assert.assertNull("parse matrix should not instantiate an expressive matrix if the fxg node DOES NOT contain a matrix", displayObject.matrix);
//		}
		
		[Test]
		public function testParseColorTransformInstantiatesColorTransformObject():void
		{
			var fxgNode:XML = <DisplayObject><transform><Transform><colorTransform><ColorTransform/></colorTransform></Transform></transform></DisplayObject>;
			displayObject.parseColorTransform(fxgNode, namingTracker, library);
			Assert.assertNotNull("parse matrix should instantiate an expressive matrix if the fxg node contains a matrix", displayObject.expressiveColorTransform);
		}
		
		[Test]
		public function testParseColorTransformDoesntInstantiateColorTransformIfNoColorTransformChildExistsInSourceXML():void
		{
			var fxgNode:XML = <DisplayObject></DisplayObject>;
			displayObject.parseColorTransform(fxgNode, namingTracker, library);
			Assert.assertNull("parse matrix should not instantiate an expressive matrix if the fxg node DOES NOT contain a matrix", displayObject.expressiveColorTransform);
		}
		
		[Test]
		public function testParseMask():void
		{
			var explicitMaskId:String = "helloMask";
			var fxgNode:XML = <DisplayObject><mask><Rect id={explicitMaskId} /></mask></DisplayObject>;
			displayObject.parseMask(fxgNode, namingTracker, library);
			Assert.assertNotNull("Display object should contain a mask", displayObject.mask);
			Assert.assertTrue("mask should have parsed all of its appropriate properties", displayObject.mask.explicitId == explicitMaskId);
			
		}
		
		// Filters related tests
		
		[Test]
		public function testParseFiltersLeavesFilterListAloneIfNoFilterXMLDataProvided():void
		{
			var source:XML = <DisplayObject/>;
			Assert.assertTrue('expressive display objects default to having an empty filter vector', displayObject.filters.length == 0);
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters produces no filter objects if no filter related xml data provided', displayObject.filters.length == 0);
		}
		
		[Test]
		public function testParseFiltersFindsAndGeneratesBevelFilter():void
		{
			var source:XML = <DisplayObject><filters><BevelFilter/></filters></DisplayObject>;
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters detects BevelFilter', displayObject.filters.length == 1);
			Assert.assertTrue('parseFilters generates appropriate expressive object for BevelFilter', displayObject.filters[0] is ExpressiveBevelFilter);
		}
		
		[Test]
		public function testParseFiltersFindsAndGeneratesColorMatrixFilter():void
		{
			var source:XML = <DisplayObject><filters><ColorMatrixFilter/></filters></DisplayObject>;
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters detects ColorMatrixFilter', displayObject.filters.length == 1);
			Assert.assertTrue('parseFilters generates appropriate expressive object for ColorMatrixFilter', displayObject.filters[0] is ExpressiveColorMatrixFilter);
		}
		
		[Test]
		public function testParseFiltersFindsAndGeneratesDropShadowFilter():void
		{
			var source:XML = <DisplayObject><filters><DropShadowFilter/></filters></DisplayObject>;
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters detects DropShadowFilter', displayObject.filters.length == 1);
			Assert.assertTrue('parseFilters generates appropriate expressive object for DropShadowFilter', displayObject.filters[0] is ExpressiveDropShadowFilter);
		}
		
		[Test]
		public function testParseFiltersFindsAndGeneratesGlowFilter():void
		{
			var source:XML = <DisplayObject><filters><GlowFilter/></filters></DisplayObject>;
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters detects GlowFilter', displayObject.filters.length == 1);
			Assert.assertTrue('parseFilters generates appropriate expressive object for GlowFilter', displayObject.filters[0] is ExpressiveGlowFilter);
		}
		
		[Test]
		public function testParseFiltersFindsAndGeneratesGradientBevelFilter():void
		{
			var source:XML = <DisplayObject><filters><GradientBevelFilter/></filters></DisplayObject>;
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters detects GradientBevelFilter', displayObject.filters.length == 1);
			Assert.assertTrue('parseFilters generates appropriate expressive object for GradientBevelFilter', displayObject.filters[0] is ExpressiveGradientBevelFilter);
		}
		
		[Test]
		public function testParseFiltersFindsAndGeneratesGradientGlowFilter():void
		{
			var source:XML = <DisplayObject><filters><GradientGlowFilter/></filters></DisplayObject>;
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters detects GradientGlowFilter', displayObject.filters.length == 1);
			Assert.assertTrue('parseFilters generates appropriate expressive object for GradientGlowFilter', displayObject.filters[0] is ExpressiveGradientGlowFilter);
		}
		
		[Test]
		public function testParseFiltersDetectsMultipleFilters():void
		{
			var source:XML = <DisplayObject><filters><BevelFilter/><GradientGlowFilter/></filters></DisplayObject>;
			displayObject.parseFilters(source, namingTracker, library);
			Assert.assertTrue('parseFilters detects GradientGlowFilter', displayObject.filters.length == 2);
		}
		
		[Test]
		public function testClone():void
		{
			var copy:ExpressiveDisplayObject = displayObject.clone(namingTracker);
			Assert.assertNotNull('clone produces object', copy);
			Assert.assertTrue('clone object a distinct instance from the original', copy != displayObject);
			Assert.assertTrue('clone tracking id distinct from original tracking id', copy.trackingId != displayObject.trackingId);
			Assert.assertTrue('clone produces object of the right type', copy is ExpressiveDisplayObject);
		}
		
		[Test]
		public function testToAS3String():void
		{
			Assert.fail("Test method Not yet implemented");
		}
	}
}