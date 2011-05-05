package spark.primitives.supportClasses
{
	import flash.geom.Point;
	
	/**
	 *  Utility class to store the computed quadratic points.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class QuadraticPoints
	{
		public var control1:Point;
		public var anchor1:Point;
		public var control2:Point;
		public var anchor2:Point;
		public var control3:Point;
		public var anchor3:Point;
		public var control4:Point;
		public var anchor4:Point;
		
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function QuadraticPoints()
		{
			super();
		}
	}
}