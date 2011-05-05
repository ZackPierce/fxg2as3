package fxg2as3.graphics
{
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	import fxg2as3.IFXGReader;
	import fxg2as3.ISimpleAS3Writer;
	import fxg2as3.NamingTracker;
	
	public class ExpressiveColorTransform extends ColorTransform implements IFXGReader, ISimpleAS3Writer
	{
		public function ExpressiveColorTransform(redMultiplier:Number=1.0, greenMultiplier:Number=1.0, blueMultiplier:Number=1.0, alphaMultiplier:Number=1.0, redOffset:Number=0, greenOffset:Number=0, blueOffset:Number=0, alphaOffset:Number=0)
		{
			super(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty("@alphaMultiplier"))
			{
				alphaMultiplier = Number(fxgNode.@alphaMultiplier.toString());
			}
			if (fxgNode.hasOwnProperty("@alphaOffset"))
			{
				alphaOffset = Number(fxgNode.@alphaOffset.toString());
			}
			if (fxgNode.hasOwnProperty("@blueMultiplier"))
			{
				blueMultiplier = Number(fxgNode.@blueMultiplier.toString());
			}
			if (fxgNode.hasOwnProperty("@blueOffset"))
			{
				blueOffset = Number(fxgNode.@blueOffset.toString());
			}
			if (fxgNode.hasOwnProperty("@greenMultiplier"))
			{
				greenMultiplier = Number(fxgNode.@greenMultiplier.toString());
			}
			if (fxgNode.hasOwnProperty("@greenOffset"))
			{
				greenOffset = Number(fxgNode.@greenOffset.toString());
			}
			if (fxgNode.hasOwnProperty("@redMultiplier"))
			{
				redMultiplier = Number(fxgNode.@redMultiplier.toString());
			}
			if (fxgNode.hasOwnProperty("@redOffset"))
			{
				redOffset = Number(fxgNode.@redOffset.toString());
			}
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return "new ColorTransform(" + [redMultiplier.toString(), greenMultiplier.toString(), blueMultiplier.toString(), alphaMultiplier.toString(), redOffset.toString(), greenOffset.toString(), blueOffset.toString(), alphaOffset.toString()].join(",") + ")";
		}
		
		public function expressiveClone():ExpressiveColorTransform
		{
			return new ExpressiveColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
		}
	}
}