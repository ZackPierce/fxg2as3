package fxg2as3.filters
{
	import flash.utils.Dictionary;
	
	import fxg2as3.ExpressiveGradientUtil;
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;
	
	import mx.graphics.GradientEntry;
	
	import spark.filters.GradientBevelFilter;
	
	public class ExpressiveGradientBevelFilter extends GradientBevelFilter implements IExpressiveFilter
	{
		
		public function ExpressiveGradientBevelFilter(distance:Number=4.0, angle:Number=45, colors:Array=null, alphas:Array=null, ratios:Array=null, blurX:Number=4.0, blurY:Number=4.0, strength:Number=1, quality:int=1, type:String="inner", knockout:Boolean=false)
		{
			super(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			entries = ExpressiveGradientUtil.generateGradientEntryArray(fxgNode); // Handles colors, alphas, ratios
			
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
			var localColors:Array = [];
			var localAlphas:Array = [];
			var localRatios:Array = [];
			var ratioConvert:Number = 255;
			for each (var gradientEntry:GradientEntry in entries)
			{
				localColors.push(gradientEntry.color);
				localAlphas.push(gradientEntry.alpha);
				localRatios.push(int(gradientEntry.ratio*ratioConvert));
			}
			return new ExpressiveGradientBevelFilter(distance, angle, localColors, localAlphas, localRatios, blurX, blurY, strength, quality, type, knockout);
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var localColors:Array = [];
			var localAlphas:Array = [];
			var localRatios:Array = [];
			var ratioConvert:Number = 255;
			for each (var gradientEntry:GradientEntry in entries)
			{
				localColors.push(gradientEntry.color);
				localAlphas.push(gradientEntry.alpha);
				localRatios.push(int(gradientEntry.ratio*ratioConvert));
			}
			return 'new GradientBevelFilter(' + distance + ', ' + angle + ', ' + FXGConverter.getExecutableArrayString(localColors, FXGConverter.convertColorUintToHexString) + ', ' + FXGConverter.getExecutableArrayString(localAlphas) + ', ' + FXGConverter.getExecutableArrayString(localRatios) + ', ' + blurX + ', ' + blurY + ', ' + strength + ', '+ quality + ', "' + type + '", ' + knockout + ')';
		}
	}
}