package fxg2as3.filters
{
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;
	
	import spark.filters.BlurFilter;
	
	public class ExpressiveBlurFilter extends BlurFilter implements IExpressiveFilter
	{
		public function ExpressiveBlurFilter(blurX:Number=4.0, blurY:Number=4.0, quality:int=1)
		{
			super(blurX, blurY, quality);
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return 'new BlurFilter(' + [blurX, blurY, quality].join(', ') + ')';
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty("@blurX"))
			{
				this.blurX = Number(fxgNode.@blurX.toString());
			}
			if (fxgNode.hasOwnProperty("@blurY"))
			{
				this.blurY = Number(fxgNode.@blurY.toString());
			}
			if (fxgNode.hasOwnProperty("@quality"))
			{
				this.quality = Number(fxgNode.@quality.toString());
			}
		}
		
		public function cloneFilter():IExpressiveFilter
		{
			return new ExpressiveBlurFilter(blurX, blurY, quality);
		}
	}
}