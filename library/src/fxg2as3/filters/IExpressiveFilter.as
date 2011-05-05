package fxg2as3.filters
{
	import fxg2as3.IFXGReader;
	import fxg2as3.ISimpleAS3Writer;

	public interface IExpressiveFilter extends ISimpleAS3Writer, IFXGReader
	{
		function cloneFilter():IExpressiveFilter;
	}
}