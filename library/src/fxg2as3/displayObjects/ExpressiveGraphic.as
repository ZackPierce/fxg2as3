package fxg2as3.displayObjects
{
	import flash.utils.Dictionary;
	
	import fxg2as3.NamingTracker;

	public class ExpressiveGraphic extends ExpressiveGroup
	{
		public var library:Dictionary;
		
		public function ExpressiveGraphic()
		{
			super();
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			if (!namingTracker) {
				namingTracker = new NamingTracker();
			}
			if (!library) {
				this.library = generateLibraryDictionary(fxgNode, namingTracker);
			} else {
				this.library = library;
			}
			super.populateFromFXG(fxgNode, namingTracker, this.library);
		}
		
		public function generateLibraryDictionary(graphicNode:XML, namingTracker:NamingTracker):Dictionary
		{
			var localLibrary:Dictionary = new Dictionary(false);
			var foundDefinitions:XMLList = graphicNode.*::Library.*::Definition;
			for each (var definitionNode:XML in foundDefinitions)
			{
				if (definitionNode.hasOwnProperty("@name"))
				{
					var definitionGroup:ExpressiveGroup = new ExpressiveGroup();
					definitionGroup.populateFromFXG(definitionNode, namingTracker, localLibrary);
					localLibrary[definitionNode.@name.toString()] = definitionGroup;
				}
			}
			return localLibrary;
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshCopy:ExpressiveGraphic = new ExpressiveGraphic();
			freshCopy.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshCopy, namingTracker);
			transferDuplicateGroupProperties(this, freshCopy, namingTracker);
			return freshCopy;
		}
	}
}