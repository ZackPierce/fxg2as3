package fxg2as3.displayObjects
{
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;

	public class ExpressiveDisplayObjectFactory
	{
		public static var supportedDisplayChildrenNames:Array = ["BitmapImage", "Ellipse", "Graphic", "Group", "Line", "Path", "Rect", "RichText", "DesignLayer", "Application"];
		
		public function ExpressiveDisplayObjectFactory()
		{
		}
		
		public static function generateExpressiveDisplayObjectFromFXGNode(node:XML, namingTracker:NamingTracker, library:Dictionary):ExpressiveDisplayObject
		{
			var nodeName:String = node.localName() ? node.localName().toString() : null;
			if (!nodeName || nodeName == null || !(supportedDisplayChildrenNames.indexOf(nodeName) >= 0 || (library && library.hasOwnProperty(nodeName))))
			{
				return null;
			}
			if (library && library.hasOwnProperty(nodeName))
			{
				var libraryGroupClone:ExpressiveGroup = (library[nodeName] as ExpressiveGroup).clone(namingTracker) as ExpressiveGroup;
				libraryGroupClone.populateFromFXG(node, namingTracker, library);
				return libraryGroupClone;
			}
			if (supportedDisplayChildrenNames.indexOf(nodeName) >= 0)
			{
				var expressiveDisplayObject:ExpressiveDisplayObject;
				switch(nodeName)
				{
					case "BitmapImage":
						expressiveDisplayObject = new ExpressiveBitmapImage();
						break;
					case "Ellipse":
						expressiveDisplayObject = new ExpressiveEllipseShape();
						break;
					case "Graphic":
					case "Application":
					case "DesignLayer":
						expressiveDisplayObject = new ExpressiveGraphic();
						break;
					case "Group":
						expressiveDisplayObject = new ExpressiveGroup();
						break;
					case "Line":
						expressiveDisplayObject = new ExpressiveLineShape();
						break;
					case "Path":
						expressiveDisplayObject = new ExpressivePathShape();
						break;
					case "Rect":
						expressiveDisplayObject = new ExpressiveRectShape();
						break;
					case "RichText":
						expressiveDisplayObject = new ExpressiveRichText();
						break;
				}
				if (expressiveDisplayObject)
				{
					expressiveDisplayObject.trackingId = namingTracker.getNextId();
					expressiveDisplayObject.populateFromFXG(node, namingTracker, library);
				}
				return expressiveDisplayObject;
				
			}
			return null;
		}
	}
}