package fxg2as3.supportClasses
{
	import flash.geom.Matrix;
	
	import fxg2as3.ICoordinateSpaceTransformable;
	
	public class BasicCoordinateSpaceTransformable implements ICoordinateSpaceTransformable
	{
		[Bindable] public var x:Number;
		[Bindable] public var y:Number;
		[Bindable] public var scaleX:Number;
		[Bindable] public var scaleY:Number;
		[Bindable] public var rotation:Number;
		[Bindable] public var matrix:Matrix;
		
		
		public function BasicCoordinateSpaceTransformable()
		{
		}
	}
}