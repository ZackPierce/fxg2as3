package fxg2as3.graphics
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;

	public class ExpressiveSolidColorFill implements IExpressiveFill
	{
		public var color:uint = 0x000000;
		public var alpha:Number = 1.0;
		
		public function ExpressiveSolidColorFill(color:uint = 0x000000, alpha:Number = 1.0)
		{
			this.color = color;
			this.alpha = alpha;
		}
		
		public function getBeginningAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle, targetFlex3:Boolean):String
		{
			return '\n' + targetGraphicsIdentifier + '.beginFill(' + FXGConverter.convertColorUintToHexString(this.color) + ', ' + this.alpha + ');';
		}
		
		public function getEndingAS3String(targetGraphicsIdentifier:String):String
		{
			return '\n' + targetGraphicsIdentifier + '.endFill();';
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (fxgNode.hasOwnProperty('@color'))
			{
				this.color = FXGConverter.parseColorHashStringToUint(fxgNode.@color.toString());
			}
			if (fxgNode.hasOwnProperty('@alpha'))
			{
				this.alpha = Number(fxgNode.@alpha.toString());
			}
		}
		
		public function expressiveClone(namingTracker:NamingTracker = null):IExpressiveFill
		{
			return new ExpressiveSolidColorFill(color, alpha);
		}
	}
}