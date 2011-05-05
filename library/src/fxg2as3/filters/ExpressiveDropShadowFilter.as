package fxg2as3.filters
{
	import flash.utils.Dictionary;
	
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;
	
	import spark.filters.DropShadowFilter;
	
	public class ExpressiveDropShadowFilter extends DropShadowFilter implements IExpressiveFilter
	{
		public function ExpressiveDropShadowFilter(distance:Number=4.0, angle:Number=45, color:uint=0, alpha:Number=1.0, blurX:Number=4.0, blurY:Number=4.0, strength:Number=1.0, quality:int=1, inner:Boolean=false, knockout:Boolean=false, hideObject:Boolean=false)
		{
			super(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return 'new DropShadowFilter(' + distance + ', ' + angle + ', ' + FXGConverter.convertColorUintToHexString(color) + ', ' + alpha + ', ' + blurX + ', ' + blurY + ', ' + strength + ', ' + quality + ', ' + inner + ', ' + knockout + ', ' + hideObject + ')';
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty("@alpha"))
			{
				this.alpha = Number(fxgNode.@alpha.toString());
			}
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
			if (fxgNode.hasOwnProperty("@color"))
			{
				this.color = FXGConverter.parseColorHashStringToUint(fxgNode.@color.toString());
			}
			if (fxgNode.hasOwnProperty("@distance"))
			{
				this.distance = Number(fxgNode.@distance.toString());
			}
			if (fxgNode.hasOwnProperty("@hideObject"))
			{
				this.hideObject = fxgNode.@hideObject.toString() == "true";
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
		
		public function cloneFilter():IExpressiveFilter
		{
			return new ExpressiveDropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		}
	}
}