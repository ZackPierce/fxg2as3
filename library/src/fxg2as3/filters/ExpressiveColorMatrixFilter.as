package fxg2as3.filters
{
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;
	
	import spark.filters.ColorMatrixFilter;
	
	public class ExpressiveColorMatrixFilter extends ColorMatrixFilter implements IExpressiveFilter
	{
		public function ExpressiveColorMatrixFilter(matrix:Array=null)
		{
			super(matrix);
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return 'new ColorMatrixFilter(' + (matrix as Array ? '[' + (matrix as Array).join(',') + ']': 'null') + ')';
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty("@matrix"))
			{
				var localData:Array = [];
				var matrixBits:Array = fxgNode.@matrix.toString().split(",");
				for (var i:int = 0; i < matrixBits.length && i < 20; i++)
				{
					localData.push(parseFloat(matrixBits[i]));
				}
				matrix = localData;
			}
		}
		
		public function cloneFilter():IExpressiveFilter
		{
			return new ExpressiveColorMatrixFilter(matrix as Array);
		}
	}
}