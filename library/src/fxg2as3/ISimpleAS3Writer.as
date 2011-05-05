package fxg2as3
{
	public interface ISimpleAS3Writer
	{
		function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String;
	}
}