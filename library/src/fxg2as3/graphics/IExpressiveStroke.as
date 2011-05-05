package fxg2as3.graphics
{
	import flash.geom.Rectangle;
	
	import fxg2as3.IFXGReader;
	import fxg2as3.NamingTracker;

	public interface IExpressiveStroke extends IFXGReader
	{
		function getAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle):String;
		function expressiveClone(namingTracker:NamingTracker = null):IExpressiveStroke;
		
		function get caps():String;
		function set caps(value:String):void;
		
		function get joints():String;
		function set joints(value:String):void;
		
		function get miterLimit():Number;
		function set miterLimit(value:Number):void;
		
		function get pixelHinting():Boolean;
		function set pixelHinting(value:Boolean):void;
		
		function get scaleMode():String;
		function set scaleMode(value:String):void;
		
		function get weight():Number;
		function set weight(value:Number):void;
		
	}
}