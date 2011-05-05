package fxg2as3
{
	import flash.geom.Matrix;

	public class CoordinateSpaceTransformableUtil
	{
		public function CoordinateSpaceTransformableUtil()
		{
		}
		
		public static function populateCoordinateSpaceTransformableFromFXG(target:ICoordinateSpaceTransformable, fxgNode:XML, applyDefaults:Boolean):void
		{
			parseMatrix(target, fxgNode); // Matrix needs to be parsed first since some matrix setters reset scaleX and scaleY to NaN
			populateCoordinateSpaceTransformAttributesFromFXG(target, fxgNode, applyDefaults);
		}
		
		protected static function populateCoordinateSpaceTransformAttributesFromFXG(target:ICoordinateSpaceTransformable, fxgNode:XML, applyDefaults:Boolean):void
		{
			if (fxgNode.hasOwnProperty("@x"))
			{
				target.x = Number(fxgNode.@x.toString());
			}
			else if (applyDefaults)
			{
				target.x = 0;
			}
			if (fxgNode.hasOwnProperty("@y"))
			{
				target.y = Number(fxgNode.@y.toString());
			}
			else if (applyDefaults)
			{
				target.y = 0;
			}
			if (fxgNode.hasOwnProperty("@scaleX"))
			{
				target.scaleX = Number(fxgNode.@scaleX.toString());
			}
			else if (applyDefaults)
			{
				target.scaleX = 1;
			}
			if (fxgNode.hasOwnProperty("@scaleY"))
			{
				target.scaleY = Number(fxgNode.@scaleY.toString());
			}
			else if (applyDefaults)
			{
				target.scaleY = 1;
			}
			if (fxgNode.hasOwnProperty("@rotation"))
			{
				target.rotation = Number(fxgNode.@rotation.toString());
			}
			else if (applyDefaults)
			{
				target.rotation = 0;
			}
		}
		
		protected static function parseMatrix(target:ICoordinateSpaceTransformable, fxgNode:XML):Boolean
		{
			var foundMatrices:XMLList = fxgNode.*::matrix.*::Matrix; 
			if (foundMatrices.length() == 0)
			{
				foundMatrices = fxgNode.*::transform.*::Transform.*::matrix.*::Matrix;
			}
			if (foundMatrices.length() > 0)
			{
				var matrixNode:XML = foundMatrices[0] as XML;
				target.matrix = new Matrix();
				populateMatrixFromFXG(target.matrix, matrixNode);
				return true;
			}
			return false;
		}
		
		protected static function populateMatrixFromFXG(matrix:Matrix, fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty("@a"))
			{
				matrix.a = Number(fxgNode.@a.toString());
			}
			if (fxgNode.hasOwnProperty("@b"))
			{
				matrix.b = Number(fxgNode.@b.toString());
			}
			if (fxgNode.hasOwnProperty("@c"))
			{
				matrix.c = Number(fxgNode.@c.toString());
			}
			if (fxgNode.hasOwnProperty("@d"))
			{
				matrix.d = Number(fxgNode.@d.toString());
			}
			if (fxgNode.hasOwnProperty("@tx"))
			{
				matrix.tx = Number(fxgNode.@tx.toString());
			}
			if (fxgNode.hasOwnProperty("@ty"))
			{
				matrix.ty = Number(fxgNode.@ty.toString());
			}
		}
		
		public static function matrixToAS3String(matrix:Matrix):String
		{
			if (matrix) {
				return "new Matrix(" + matrix.a + ", " + matrix.b + ", " + matrix.c + ", " + matrix.d + ", " + matrix.tx + ", " + matrix.ty + ")";
			} else {
				return "null";
			}
			
		}
		
		public static function transferDuplicateCoordinateSpaceProperties(source:ICoordinateSpaceTransformable, sink:ICoordinateSpaceTransformable):void
		{
			sink.matrix = source.matrix ? source.matrix.clone() : null;
			sink.x = source.x;
			sink.y = source.y;
			sink.scaleX = source.scaleX;
			sink.scaleY = source.scaleY;
			sink.rotation = source.rotation;
		}
	}
}