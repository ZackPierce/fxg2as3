package fxg2as3
{
	import flash.display.BitmapData;

	public interface ISourceBitmapUser
	{
		function get referenceBitmapData():BitmapData;
		function set referenceBitmapData(pReferenceBitmapData:BitmapData):void;
		
		function get bitmapSourcePath():String;
	}
}