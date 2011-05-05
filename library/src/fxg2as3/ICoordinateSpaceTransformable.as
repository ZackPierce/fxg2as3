package fxg2as3
{
	import flash.geom.Matrix;

	public interface ICoordinateSpaceTransformable
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		
		function get rotation():Number;
		function set rotation(value:Number):void;
		
		function get matrix():Matrix;
		function set matrix(value:Matrix):void;
	}
}