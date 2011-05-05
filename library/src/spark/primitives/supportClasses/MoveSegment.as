package spark.primitives.supportClasses
{
	import flash.display.GraphicsPath;

	/**
	 *  The MoveSegment moves the pen to the x,y position. This class calls the <code>Graphics.moveTo()</code> method 
	 *  from the <code>draw()</code> method.
	 * 
	 *  
	 *  @see flash.display.Graphics
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class MoveSegment extends PathSegment
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @param x The target x-axis location in 2-d coordinate space.
		 *  
		 *  @param y The target y-axis location in 2-d coordinate space.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function MoveSegment(x:Number = 0, y:Number = 0)
		{
			super(x, y);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 * 
		 *  The MoveSegment class moves the pen to the position specified by the
		 *  x and y properties.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
		{
			graphicsPath.moveTo(dx+x*sx, dy+y*sy);
		}
	}
}