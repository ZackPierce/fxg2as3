package fxg2as3
{
	import flash.geom.Matrix;
	
	import flexunit.framework.Assert;
	
	import fxg2as3.supportClasses.BasicCoordinateSpaceTransformable;
	
	public class CoordinateSpaceTransformableUtilTest
	{
		protected var basicCoordinateSpaceTransformable:BasicCoordinateSpaceTransformable;
		protected var namingTracker:NamingTracker;
		
		[Before]
		public function setUp():void
		{
			basicCoordinateSpaceTransformable = new BasicCoordinateSpaceTransformable();
			namingTracker = new NamingTracker();
		}
		
		[After]
		public function tearDown():void
		{
			basicCoordinateSpaceTransformable = null;
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
		public function testMatrixToAS3String():void
		{
			var matrix:Matrix = new Matrix(1, 2, 3, 4, 5, 6);
			var idealCode:String = 'new Matrix(1, 2, 3, 4, 5, 6)';
			var outputCode:String = CoordinateSpaceTransformableUtil.matrixToAS3String(matrix);
			Assert.assertNotNull('Code string generated must for an extant Matrix not be null', outputCode);
			Assert.assertTrue('Matrix AS3 code should match input matrix object', outputCode == idealCode); 
		}
		
		[Test]
		public function testMatrixToAS3StringForNullInput():void
		{
			var matrix:Matrix = null;
			var idealCode:String = 'null';
			var outputCode:String = CoordinateSpaceTransformableUtil.matrixToAS3String(matrix);
			Assert.assertNotNull('Code string generated must for a null mmatrix should not be a null', outputCode);
			Assert.assertTrue('Matrix AS3 code for a null input be a string saying the word "null"', outputCode == idealCode); 
		}
		
		[Test]
		public function testPopulateCoordinateSpaceTransformableFromFXG():void
		{
			var x:Number = 1;
			var y:Number = 2;
			var scaleX:Number = 3;
			var scaleY:Number = 4;
			var rotation:Number = 5;
			var matrix:Matrix = new Matrix(1, 2, 3, 4, 5, 6);
			var source:XML = <Herp x={x} y={y} scaleX={scaleX} scaleY={scaleY} rotation={rotation}><matrix><Matrix a={matrix.a} b={matrix.b} c={matrix.c} d={matrix.d} tx={matrix.tx} ty={matrix.ty} /></matrix></Herp>
			CoordinateSpaceTransformableUtil.populateCoordinateSpaceTransformableFromFXG(basicCoordinateSpaceTransformable, source, false);
			Assert.assertTrue('ICoordinateSpaceTransformable sink x value should match source xml value', x == basicCoordinateSpaceTransformable.x);
			Assert.assertTrue('ICoordinateSpaceTransformable sink y value should match source xml value', y == basicCoordinateSpaceTransformable.y);
			Assert.assertTrue('ICoordinateSpaceTransformable sink scaleX value should match source xml value', scaleX == basicCoordinateSpaceTransformable.scaleX);
			Assert.assertTrue('ICoordinateSpaceTransformable sink scaleY value should match source xml value', scaleY == basicCoordinateSpaceTransformable.scaleY);
			Assert.assertTrue('ICoordinateSpaceTransformable sink rotation value should match source xml value', rotation == basicCoordinateSpaceTransformable.rotation);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix a value should match source xml value', matrix.a == basicCoordinateSpaceTransformable.matrix.a);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix b value should match source xml value', matrix.b == basicCoordinateSpaceTransformable.matrix.b);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix c value should match source xml value', matrix.c == basicCoordinateSpaceTransformable.matrix.c);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix d value should match source xml value', matrix.d == basicCoordinateSpaceTransformable.matrix.d);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix tx value should match source xml value', matrix.tx == basicCoordinateSpaceTransformable.matrix.tx);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix ty value should match source xml value', matrix.ty == basicCoordinateSpaceTransformable.matrix.ty);
		}
		
		[Test]
		public function testPopulateCoordinateSpaceTransformableFromFXGApplyingDefaults():void
		{
			var x:Number = 0;
			var y:Number = 0;
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			var rotation:Number = 0;
			var matrix:Matrix = null;
			var source:XML = <Herp />
			CoordinateSpaceTransformableUtil.populateCoordinateSpaceTransformableFromFXG(basicCoordinateSpaceTransformable, source, true);
			Assert.assertTrue('ICoordinateSpaceTransformable sink x value should match source xml value', x == basicCoordinateSpaceTransformable.x);
			Assert.assertTrue('ICoordinateSpaceTransformable sink y value should match source xml value', y == basicCoordinateSpaceTransformable.y);
			Assert.assertTrue('ICoordinateSpaceTransformable sink scaleX value should match source xml value', scaleX == basicCoordinateSpaceTransformable.scaleX);
			Assert.assertTrue('ICoordinateSpaceTransformable sink scaleY value should match source xml value', scaleY == basicCoordinateSpaceTransformable.scaleY);
			Assert.assertTrue('ICoordinateSpaceTransformable sink rotation value should match source xml value', rotation == basicCoordinateSpaceTransformable.rotation);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix a value should match source xml value', matrix == basicCoordinateSpaceTransformable.matrix);
		}
		
		[Test]
		public function testTransferDuplicateCoordinateSpaceProperties():void
		{
			basicCoordinateSpaceTransformable.x = 1;
			basicCoordinateSpaceTransformable.y = 2;
			basicCoordinateSpaceTransformable.scaleX = 3;
			basicCoordinateSpaceTransformable.scaleY = 4;
			basicCoordinateSpaceTransformable.rotation = 5;
			basicCoordinateSpaceTransformable.matrix = new Matrix(1, 2, 3, 4, 5, 6);
			
			var sink:BasicCoordinateSpaceTransformable = new BasicCoordinateSpaceTransformable();
			CoordinateSpaceTransformableUtil.transferDuplicateCoordinateSpaceProperties(basicCoordinateSpaceTransformable, sink);
			Assert.assertTrue('ICoordinateSpaceTransformable sink x value should match source object value', sink.x == basicCoordinateSpaceTransformable.x);
			Assert.assertTrue('ICoordinateSpaceTransformable sink y value should match source object value', sink.y == basicCoordinateSpaceTransformable.y);
			Assert.assertTrue('ICoordinateSpaceTransformable sink scaleX value should match source object value', sink.scaleX == basicCoordinateSpaceTransformable.scaleX);
			Assert.assertTrue('ICoordinateSpaceTransformable sink scaleY value should match source object value', sink.scaleY == basicCoordinateSpaceTransformable.scaleY);
			Assert.assertTrue('ICoordinateSpaceTransformable sink rotation value should match source object value', sink.rotation == basicCoordinateSpaceTransformable.rotation);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix a value should match source object value', sink.matrix.a == basicCoordinateSpaceTransformable.matrix.a);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix b value should match source object value', sink.matrix.b == basicCoordinateSpaceTransformable.matrix.b);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix c value should match source object value', sink.matrix.c == basicCoordinateSpaceTransformable.matrix.c);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix d value should match source object value', sink.matrix.d == basicCoordinateSpaceTransformable.matrix.d);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix tx value should match source object value', sink.matrix.tx == basicCoordinateSpaceTransformable.matrix.tx);
			Assert.assertTrue('ICoordinateSpaceTransformable sink matrix ty value should match source object value', sink.matrix.ty == basicCoordinateSpaceTransformable.matrix.ty);
		}
	}
}