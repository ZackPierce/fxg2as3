package fxg2as3.displayObjects
{
	import flash.utils.Dictionary;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.NamingTracker;
	
	public class ExpressiveDisplayObjectFactoryTest
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
		public function testGenerateExpressiveDisplayObjectFromFXGNodeWithNoNamespace():void
		{
			Assert.assertTrue('Generates correct expressive display object for BitmapImage', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<BitmapImage/>, namingTracker, library) is ExpressiveBitmapImage);
			Assert.assertTrue('Generates correct expressive display object for Ellipse', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<Ellipse/>, namingTracker, library) is ExpressiveEllipseShape);
			Assert.assertTrue('Generates correct expressive display object for Graphic', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<Graphic/>, namingTracker, library) is ExpressiveGraphic);
			Assert.assertTrue('Generates correct expressive display object for Group', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<Group/>, namingTracker, library) is ExpressiveGroup);
			Assert.assertTrue('Generates correct expressive display object for Line', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<Line/>, namingTracker, library) is ExpressiveLineShape);
			Assert.assertTrue('Generates correct expressive display object for Path', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<Path/>, namingTracker, library) is ExpressivePathShape);
			Assert.assertTrue('Generates correct expressive display object for Rect', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<Rect/>, namingTracker, library) is ExpressiveRectShape);
			Assert.assertTrue('Generates correct expressive display object for RichText', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<RichText/>, namingTracker, library) is ExpressiveRichText);
			Assert.assertNull('Generates null when invalid fxg node given', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<HerpDerp/>, namingTracker, library));
		}
		
		[Test]
		public function testGenerateExpressiveDisplayObjectFromFXGNodeWithSparkNamespace():void
		{
			Assert.assertTrue('Generates correct expressive display object for BitmapImage', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:BitmapImage xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressiveBitmapImage);
			Assert.assertTrue('Generates correct expressive display object for Ellipse', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:Ellipse xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressiveEllipseShape);
			Assert.assertTrue('Generates correct expressive display object for Graphic', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:Graphic xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressiveGraphic);
			Assert.assertTrue('Generates correct expressive display object for Group', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:Group xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressiveGroup);
			Assert.assertTrue('Generates correct expressive display object for Line', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:Line xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressiveLineShape);
			Assert.assertTrue('Generates correct expressive display object for Path', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:Path xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressivePathShape);
			Assert.assertTrue('Generates correct expressive display object for Rect', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:Rect xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressiveRectShape);
			Assert.assertTrue('Generates correct expressive display object for RichText', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:RichText xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library) is ExpressiveRichText);
			Assert.assertNull('Generates null when invalid fxg node given', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<s:HerpDerp xmlns:s="library://ns.adobe.com/flex/spark" />, namingTracker, library));
		}
		
		[Test]
		public function testGenerateExpressiveDisplayObjectFromFXGNodeByLibraryDefinition():void
		{
			library["HerpDerp"] = new ExpressiveGroup();
			Assert.assertTrue('Generates correct expressive display object from library definition', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<HerpDerp/>, namingTracker, library) is ExpressiveGroup);
			Assert.assertTrue('Generated instance is not the same object as the definition', ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(<HerpDerp/>, namingTracker, library) != library["HerpDerp"]);
		}

	}
}