package fxg2as3.displayObjects
{
	import flash.display.BlendMode;
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;

	public class ExpressiveGroup extends ExpressiveDisplayObject
	{
		public var kids:Vector.<ExpressiveDisplayObject> = new Vector.<ExpressiveDisplayObject>();
		
		public function ExpressiveGroup()
		{
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			parseDisplayChildren(fxgNode, namingTracker, library);
		}
		
		public function parseDisplayChildren(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			var nodes:XMLList = fxgNode.children();
			for each (var node:XML in nodes)
			{
				var expressiveDisplayObject:ExpressiveDisplayObject = ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(node, namingTracker, library);
				if (expressiveDisplayObject)
				{
					kids.push(expressiveDisplayObject);
				}
			}
		}
		
		override public function parseBaseDisplayObjectAttributes(fxgNode:XML):void
		{
			super.parseBaseDisplayObjectAttributes(fxgNode);
			if (this.blendMode == "auto")
			{
				this.blendMode = (alpha > 0 && alpha < 1) ? BlendMode.LAYER : BlendMode.NORMAL;
			}
		}
		
		override public function getInstanceName():String
		{
			return explicitId ? explicitId : "group" + trackingId;
		}
		
		override public function getInstantiationAS3(targetFlex3:Boolean):String
		{
			return '\nvar ' + getInstanceName() + ":Sprite = new Sprite();";
		}
		
		override public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var out:String = super.toAS3String(targetFlex3, useVectorNotation, numericPrintingPrecision);
			for each (var kid:ExpressiveDisplayObject in kids)
			{
				out += '\n' + kid.toAS3String(targetFlex3, useVectorNotation, numericPrintingPrecision);
				if (kid.mask)
				{
					out += '\n' + this.getInstanceName() + '.addChild(' + kid.mask.getInstanceName() + ');';
				}
				out += '\n' + this.getInstanceName() + '.addChild(' + kid.getInstanceName() + ');';
			}
			return out;
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshCopy:ExpressiveGroup = new ExpressiveGroup();
			freshCopy.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshCopy, namingTracker);
			transferDuplicateGroupProperties(this, freshCopy, namingTracker);
			return freshCopy;
		}
		
		public static function transferDuplicateGroupProperties(source:ExpressiveGroup, sink:ExpressiveGroup, namingTracker:NamingTracker):void
		{
			var kidsCopies:Vector.<ExpressiveDisplayObject> = new Vector.<ExpressiveDisplayObject>();
			for each (var expressiveDisplayObject:ExpressiveDisplayObject in source.kids)
			{
				kidsCopies.push(expressiveDisplayObject.clone(namingTracker));
			}
			sink.kids = kidsCopies;
		}
	}
}