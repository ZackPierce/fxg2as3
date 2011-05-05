package fxg2as3
{
	import flash.utils.Dictionary;
	
	import fxg2as3.displayObjects.ExpressiveDisplayObject;
	import fxg2as3.displayObjects.ExpressiveDisplayObjectFactory;
	import fxg2as3.displayObjects.ExpressiveGroup;
	import fxg2as3.displayObjects.ExpressiveShape;
	
	public class FXGConverter
	{
		
		public function FXGConverter()
		{
		}
		
		public static function convertColorUintToHexString(pColor:uint):String
		{
			var short:String = pColor.toString(16).toUpperCase();
			while (short.length < 6)
			{
				short = "0" + short;
			}
			return "0x" + short;
		}
		
		public static function parseColorHashStringToUint(pColorString:String):uint {
			return parseInt(pColorString.replace("#", "0x"), 16);
		}
		
		public static function generateAS3FromFXGNode(node:XML, targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var expressiveDisplayObject:ExpressiveDisplayObject = ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(node, new NamingTracker(), null);
			var as3:String = generateAS3FromExpressiveDisplayObject(expressiveDisplayObject, targetFlex3, useVectorNotation, numericPrintingPrecision);
			return as3;
		}
		
		public static function generateAS3FromExpressiveDisplayObject(expressiveDisplayObject:ExpressiveDisplayObject, targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var as3:String;
			if (expressiveDisplayObject)
			{
				as3 = expressiveDisplayObject.toAS3String(targetFlex3, useVectorNotation, numericPrintingPrecision);
				/* ExpressiveDisplayObject.toAS3String() relies on the parent of the relevant ExpressiveDisplayObject to
				*   add code that adds the mask to the displayList (see ExpressiveGroup.toAS3String).
				*  Since this expressiveDisplayObject is root, and has no parent, we add the mask here.
				*/
				if (expressiveDisplayObject.mask)  
				{
					as3 += "addChild(" + expressiveDisplayObject.mask.getInstanceName() + ');';
				}
			}
			return as3;
		}
		
		// Simple external-facing wrapper around ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode for external use
		public static function generateExpressiveDisplayObjectFromFXG(node:XML):ExpressiveDisplayObject
		{
			return ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(node, new NamingTracker(), new Dictionary());
		}
		
		// TBD - Consider ramifications that a null array reference will currently be expressed as an empty array, '[]'
		public static function getExecutableArrayString(array:Array, arrayEntryStringifier:Function = null):String
		{
			if (!array)
			{
				return '[]';
			}
			var arrayCode:String = '[';
			var length:int = array.length;
			for (var i:int = 0; i < length; i++)
			{
				if (arrayEntryStringifier != null)
				{
					arrayCode += arrayEntryStringifier.call(null, array[i]);
				}
				else
				{
					arrayCode += array[i].toString();
				}
				if (i < length - 1)
				{
					arrayCode += ', ';
				}
			}
			arrayCode += ']';
			return arrayCode;
		}
		
		public static function findISourceBitmapUsers(target:ExpressiveDisplayObject):Vector.<ISourceBitmapUser>
		{
			var sourceBitmapUsers:Vector.<ISourceBitmapUser> = new Vector.<ISourceBitmapUser>();
			appendNestedISourceBitmapUsers(target, sourceBitmapUsers);
			return sourceBitmapUsers;
		}
		
		private static function appendNestedISourceBitmapUsers(target:ExpressiveDisplayObject, outputList:Vector.<ISourceBitmapUser>):void
		{
			if (!outputList || !target)
			{
				return;
			}
			if (target is ISourceBitmapUser)
			{
				outputList.push(target);
			}
			// TBD - mask!
			if (target is ExpressiveShape && (target as ExpressiveShape).fill && (target as ExpressiveShape).fill is ISourceBitmapUser)
			{
				outputList.push((target as ExpressiveShape).fill as ISourceBitmapUser);
			}
			if (target is ExpressiveGroup && (target as ExpressiveGroup).kids)
			{
				var kidsCache:Vector.<ExpressiveDisplayObject> = (target as ExpressiveGroup).kids;
				for each (var kid:ExpressiveDisplayObject in kidsCache)
				{
					appendNestedISourceBitmapUsers(kid, outputList);
				}
			}
		}
	}
}