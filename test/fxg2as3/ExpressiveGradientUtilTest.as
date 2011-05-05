package fxg2as3
{
	import flexunit.framework.Assert;
	
	import mx.graphics.GradientEntry;
	
	public class ExpressiveGradientUtilTest
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
		public function testCloneGradientEntry():void
		{
			var gradientEntry:GradientEntry = new GradientEntry(0xFF00FF, 0.5, 0.75);
			var entryClone:GradientEntry = ExpressiveGradientUtil.cloneGradientEntry(gradientEntry);
			Assert.assertFalse('Clone entry should not be the same object as source GradientEntry', gradientEntry === entryClone);
			Assert.assertNotNull('cloneGradientEntry does not return null for a non-null source object', entryClone);
			Assert.assertTrue('Copied color matches source value', gradientEntry.color == entryClone.color);
			Assert.assertTrue('Copied alpha matches source value', gradientEntry.alpha == entryClone.alpha);
			Assert.assertTrue('Copied ratio matches source value', gradientEntry.ratio == entryClone.ratio);
		}
		
		[Test]
		public function testCloneGradientEntryArray():void
		{
			var sourceList:Array = [new GradientEntry(0xFF00FF, 0.25, 0.75), new GradientEntry(0xAABBCC, 0.50, 0.95)];
			var cloneList:Array = ExpressiveGradientUtil.cloneGradientEntryArray(sourceList);
			Assert.assertNotNull('cloned array should not be null', cloneList);
			Assert.assertTrue('Clone array should be the same length as source array', sourceList.length == cloneList.length);
			for (var i:int = 0; i < sourceList.length; i++)
			{
				var originalEntry:GradientEntry = sourceList[i] as GradientEntry;
				var cloneEntry:GradientEntry = cloneList[i] as GradientEntry;
				Assert.assertFalse('Clone entry should not be the same object as source GradientEntry', originalEntry === cloneEntry);
				Assert.assertTrue('Copied color matches source value', originalEntry.color == cloneEntry.color);
				Assert.assertTrue('Copied alpha matches source value', originalEntry.alpha == cloneEntry.alpha);
				Assert.assertTrue('Copied ratio matches source value', originalEntry.ratio == cloneEntry.ratio);
			}
		}
		
		[Test]
		public function testGenerateGradientEntryArray():void
		{
			var source:XML = <Whatever><GradientEntry/></Whatever>;
			var gradientEntries:Array = ExpressiveGradientUtil.generateGradientEntryArray(source);
			Assert.assertNotNull('generateGradientEntryArray does not return null when the source contains an entry node', gradientEntries);
			Assert.assertTrue('generateGradientEntryArray creates the right number of entries', gradientEntries.length == 1);
			Assert.assertTrue('generateGradientEntryArray produces an array of objects of type GradientEntry', gradientEntries[0] is GradientEntry);
		}
		
		[Test]
		public function testGenerateGradientEntryArrayForNoSourceGradientEntryNodes():void
		{
			var source:XML = <Whatever></Whatever>;
			var gradientEntries:Array = ExpressiveGradientUtil.generateGradientEntryArray(source);
			Assert.assertNotNull('generateGradientEntryArray does not return null event when the source contains no GradientEntry node', gradientEntries);
			Assert.assertTrue('generateGradientEntryArray creates the right number of entries', gradientEntries.length == 0);
		}
		
		[Test]
		public function testGenerateGradientEntryArrayDetectsGradientEntrySettings():void
		{
			var testColor:uint = 0xFF00FF;
			var testAlpha:Number = 0.5;
			var testRatio:Number = 0.75;
			var source:XML = <Whatever><GradientEntry color={FXGConverter.convertColorUintToHexString(testColor)} alpha={testAlpha} ratio={testRatio}/></Whatever>;
			var gradientEntries:Array = ExpressiveGradientUtil.generateGradientEntryArray(source);
			var firstEntry:GradientEntry = gradientEntries[0] as GradientEntry;
			Assert.assertTrue('Parsed color matches source value', firstEntry.color == testColor);
			Assert.assertTrue('Parsed alpha matches source value', firstEntry.alpha == testAlpha);
			Assert.assertTrue('Parsed ratio matches source value', firstEntry.ratio == testRatio);
		}
		
		[Test]
		public function testGradientEntryToAS3String():void
		{
			var gradientEntry:GradientEntry = new GradientEntry(0xFF00FF, 0.5, 0.75);
			var expectedCode:String = 'new GradientEntry(0xFF00FF, 0.5, 0.75)';
			var entryAS3:String = ExpressiveGradientUtil.gradientEntryToAS3String(gradientEntry);
			Assert.assertNotNull('GradientEntry AS3 code should not be null', entryAS3);
			Assert.assertTrue('GradientEntry AS3 code should match expected string', entryAS3 == expectedCode);
		}
	}
}