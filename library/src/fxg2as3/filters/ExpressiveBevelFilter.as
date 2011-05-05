package fxg2as3.filters
{
	import flash.utils.Dictionary;
	
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;
	
	import spark.filters.BevelFilter;
	
	public class ExpressiveBevelFilter extends BevelFilter implements IExpressiveFilter
	{
		public function ExpressiveBevelFilter(distance:Number=4.0, angle:Number=45, highlightColor:uint=16777215, highlightAlpha:Number=1.0, shadowColor:uint=0, shadowAlpha:Number=1.0, blurX:Number=4.0, blurY:Number=4.0, strength:Number=1, quality:int=1, type:String="inner", knockout:Boolean=false)
		{
			super(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return 'new BevelFilter(' + distance + ', ' + angle + ', ' + FXGConverter.convertColorUintToHexString(highlightColor) + ', ' + highlightAlpha + ', ' + FXGConverter.convertColorUintToHexString(shadowColor) + ', ' + shadowAlpha + ', ' + blurX + ', ' + blurY + ', ' + strength + ', ' + quality + ', "' + type + '", ' + knockout + ')';
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty("@angle"))
			{
				this.angle = Number(fxgNode.@angle.toString());
			}
			if (fxgNode.hasOwnProperty("@blurX"))
			{
				this.blurX = Number(fxgNode.@blurX.toString());
			}
			if (fxgNode.hasOwnProperty("@blurY"))
			{
				this.blurY = Number(fxgNode.@blurY.toString());
			}
			if (fxgNode.hasOwnProperty("@highlightAlpha"))
			{
				this.highlightAlpha = Number(fxgNode.@highlightAlpha.toString());
			}
			if (fxgNode.hasOwnProperty("@highlightColor"))
			{
				this.highlightColor = FXGConverter.parseColorHashStringToUint(fxgNode.@angle.toString());
			}
			if (fxgNode.hasOwnProperty("@distance"))
			{
				this.distance = Number(fxgNode.@distance.toString());
			}
			if (fxgNode.hasOwnProperty("@knockout"))
			{
				this.knockout = fxgNode.@knockout.toString() == "true";
			}
			if (fxgNode.hasOwnProperty("@quality"))
			{
				this.quality = Number(fxgNode.@quality.toString());
			}
			if (fxgNode.hasOwnProperty("@shadowAlpha"))
			{
				this.shadowAlpha = Number(fxgNode.@shadowAlpha.toString());
			}
			if (fxgNode.hasOwnProperty("@shadowColor"))
			{
				this.shadowColor = FXGConverter.parseColorHashStringToUint(fxgNode.@angle.toString());
			}
			if (fxgNode.hasOwnProperty("@strength"))
			{
				this.strength = Number(fxgNode.@strength.toString());
			}
			if (fxgNode.hasOwnProperty("@type"))
			{
				this.type = fxgNode.@type.toString();
			}
		}
		
		public function cloneFilter():IExpressiveFilter
		{
			return new ExpressiveBevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
		}
	}
}