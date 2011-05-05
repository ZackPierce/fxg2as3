package fxg2as3.filters
{
	import flash.utils.Dictionary;
	
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;
	
	import spark.filters.GlowFilter;
	
	public class ExpressiveGlowFilter extends GlowFilter implements IExpressiveFilter
	{
		public function ExpressiveGlowFilter(color:uint=16711680, alpha:Number=1.0, blurX:Number=4.0, blurY:Number=4.0, strength:Number=1, quality:int=1, inner:Boolean=false, knockout:Boolean=false)
		{
			super(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return 'new GlowFilter(' + [color, alpha, blurX, blurY, strength, quality, inner, knockout].join(', ') + ')';
		}
		
		public function cloneFilter():IExpressiveFilter
		{
			return new ExpressiveGlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty("@alpha"))
			{
				this.alpha = Number(fxgNode.@alpha.toString());
			}
			if (fxgNode.hasOwnProperty("@blurX"))
			{
				this.blurX = Number(fxgNode.@blurX.toString());
			}
			if (fxgNode.hasOwnProperty("@blurY"))
			{
				this.blurY = Number(fxgNode.@blurY.toString());
			}
			if (fxgNode.hasOwnProperty("@color"))
			{
				this.color = FXGConverter.parseColorHashStringToUint(fxgNode.@color.toString());
			}
			if (fxgNode.hasOwnProperty("@inner"))
			{
				this.inner = fxgNode.@inner.toString() == "true";
			}
			if (fxgNode.hasOwnProperty("@knockout"))
			{
				this.knockout = fxgNode.@knockout.toString() == "true";
			}
			if (fxgNode.hasOwnProperty("@quality"))
			{
				this.quality = Number(fxgNode.@quality.toString());
			}
			if (fxgNode.hasOwnProperty("@strength"))
			{
				this.strength = Number(fxgNode.@strength.toString());
			}
		}
	}
}