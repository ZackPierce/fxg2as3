package fxg2as3
{
	import flash.utils.Dictionary;

	public interface IFXGReader
	{
		function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void;
	}
}