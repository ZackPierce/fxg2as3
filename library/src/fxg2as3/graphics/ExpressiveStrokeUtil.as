package fxg2as3.graphics
{
	public class ExpressiveStrokeUtil
	{
		public function ExpressiveStrokeUtil()
		{
		}
		
		public static function parseStrokePropertiesFromFXG(target:IExpressiveStroke, fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty('@weight'))
			{
				target.weight = Number(fxgNode.@weight.toString());
			}
			if (fxgNode.hasOwnProperty('@pixelHinting'))
			{
				target.pixelHinting = fxgNode.@pixelHinting.toString() == 'true';
			}
			if (fxgNode.hasOwnProperty('@scaleMode'))
			{
				target.scaleMode = fxgNode.@scaleMode.toString();
			}
			if (fxgNode.hasOwnProperty('@caps'))
			{
				target.caps = fxgNode.@caps.toString();
			}
			if (fxgNode.hasOwnProperty('@joints'))
			{
				target.joints = fxgNode.@joints.toString();
			}
			if (fxgNode.hasOwnProperty('@miterLimit'))
			{
				target.miterLimit = Number(fxgNode.@miterLimit.toString());
			}
		}
	}
}