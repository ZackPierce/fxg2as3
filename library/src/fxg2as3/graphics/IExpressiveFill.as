package fxg2as3.graphics
{
	import flash.geom.Rectangle;
	
	import fxg2as3.IFXGReader;
	import fxg2as3.NamingTracker;

	public interface IExpressiveFill extends IFXGReader
	{
		function getBeginningAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle, targetFlex3:Boolean):String;
		function getEndingAS3String(targetGraphicsIdentifier:String):String;
		function expressiveClone(namingTracker:NamingTracker = null):IExpressiveFill;
	}
}