package fxg2as3
{
	import mx.graphics.GradientBase;
	import mx.graphics.GradientEntry;

	public class ExpressiveGradientUtil
	{
		
		public function ExpressiveGradientUtil()
		{
		}
		
		public static function parseGradientSpreadAndInterpolationFromFXG(target:GradientBase, fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty('@spreadMethod'))
			{
				target.spreadMethod = fxgNode.@spreadMethod.toString();
			}
			if (fxgNode.hasOwnProperty('@interpolationMethod'))
			{
				target.interpolationMethod = fxgNode.@interpolationMethod.toString();
			}
		}
		
		public static function generateGradientEntryArray(fxgNode:XML):Array
		{
			var localEntries:Array = [];
			if (!fxgNode)
			{
				return localEntries;
			}
			var foundEntries:XMLList = fxgNode.*::GradientEntry;
			for (var e:int = 0; e < foundEntries.length(); e++)
			{
				var currentNode:XML = foundEntries[e];
				var currentEntry:GradientEntry = new GradientEntry();
				if (currentNode.hasOwnProperty('@color'))
				{
					currentEntry.color = FXGConverter.parseColorHashStringToUint(currentNode.@color.toString());
				}
				if (currentNode.hasOwnProperty('@alpha'))
				{
					currentEntry.alpha = Number(currentNode.@alpha.toString());
				}
				if (currentNode.hasOwnProperty('@ratio'))
				{
					currentEntry.ratio = Number(currentNode.@ratio.toString());
				}
				else if (e == 0)
				{
					currentEntry.ratio = 0.0;
				}
				else if (e == foundEntries.length() - 1)
				{
					currentEntry.ratio = 1.0;
				}
				else
				{
					currentEntry.ratio = NaN;
				}
				localEntries.push(currentEntry);
			}
			
			// Resolve undefined ratios - Algorithm borrowed and modified from spark.filters.GradientFilter
			var i:int = 1;
			var n:int = localEntries.length;
			
			while (localEntries.length > 0) // Expect an explicit break
			{
				while (i < n && !isNaN(localEntries[i].ratio))
				{
					i++;
				}
				
				if (i == n)
					break;
				
				var start:int = i - 1;
				
				while (i < n && isNaN(localEntries[i].ratio))
				{
					i++;
				}
				
				var br:Number = localEntries[start].ratio;
				var tr:Number = localEntries[i].ratio;
				
				for (var j:int = 1; j < i - start; j++)
				{
					localEntries[j].ratio = br + j * (tr - br) / (i - start);
				}
			}
			return localEntries;
		}
		
		public static function gradientEntryToAS3String(gradientEntry:GradientEntry):String
		{
			return 'new GradientEntry(' + FXGConverter.convertColorUintToHexString(gradientEntry.color) + ', ' + gradientEntry.ratio + ', ' + gradientEntry.alpha + ')';
		}
		
		public static function cloneGradientEntry(gradientEntry:GradientEntry):GradientEntry
		{
			return new GradientEntry(gradientEntry.color, gradientEntry.ratio, gradientEntry.alpha);
		}
		
		public static function cloneGradientEntryArray(gradientEntries:Array):Array
		{
			if (!gradientEntries)
			{
				return null;
			}
			var localEntries:Array = [];
			for each (var gradientEntry:GradientEntry in gradientEntries)
			{
				localEntries.push(cloneGradientEntry(gradientEntry));
			}
			return localEntries;
		}
	}
}