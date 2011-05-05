package fxg2as3.graphics
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.FXGConverter;
	import fxg2as3.NamingTracker;
	
	import mx.graphics.SolidColorStroke;

	public class ExpressiveSolidColorStroke extends SolidColorStroke implements IExpressiveStroke
	{	
		public function ExpressiveSolidColorStroke(weight:Number = 1, color:uint = 0x000000, alpha:Number = 1.0,
												   pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = "round",
												   joints:String = "round", miterLimit:Number = 3.0)
		{
			this.weight = weight;
			this.color = color;
			this.alpha = alpha;
			this.pixelHinting = pixelHinting;
			this.scaleMode = scaleMode;
			this.caps = caps;
			this.joints = joints;
			this.miterLimit = miterLimit;
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			// TBD - do we really need namingTracker and library here?  Probably not.
			
			if (fxgNode.hasOwnProperty('@color'))
			{
				this.color = FXGConverter.parseColorHashStringToUint(fxgNode.@color.toString());
			}
			if (fxgNode.hasOwnProperty('@alpha'))
			{
				this.alpha = Number(fxgNode.@alpha.toString());
			}
			ExpressiveStrokeUtil.parseStrokePropertiesFromFXG(this, fxgNode);
		}
		
		public function getAS3String(targetGraphicsIdentifier:String, targetBounds:Rectangle):String
		{
			return '\n' + targetGraphicsIdentifier + '.lineStyle(' + this.weight + ', ' + FXGConverter.convertColorUintToHexString(this.color) + ', ' + this.alpha + ', ' + this.pixelHinting.toString() + ', "' + this.scaleMode + '", "' + this.caps + '", "' + this.joints + '", ' + this.miterLimit + ');';
		}
		
		public function expressiveClone(namingTracker:NamingTracker = null):IExpressiveStroke
		{
			var sink:ExpressiveSolidColorStroke = new ExpressiveSolidColorStroke(this.weight, this.color, this.alpha,
																				this.pixelHinting, this.scaleMode, this.caps,
																				this.joints, this.miterLimit);
			return sink;
		}
	}
}