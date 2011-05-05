package fxg2as3.displayObjects
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.compose.StandardFlowComposer;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;
	
	import fxg2as3.IFXGReader;
	import fxg2as3.ISimpleAS3Writer;
	import fxg2as3.NamingTracker;
	
	import spark.utils.TextFlowUtil;

	public class ExpressiveRichText extends ExpressiveDisplayObject implements IFXGReader, ISimpleAS3Writer
	{
		public var textFlow:TextFlow;
		public var width:Number;
		public var height:Number;
		
		
		public function ExpressiveRichText()
		{
			super();
		}
		
		override public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			super.populateFromFXG(fxgNode, namingTracker, library);
			if (fxgNode.hasOwnProperty('@width'))
			{
				width = Number(fxgNode.@width.toString());
			}
			if (fxgNode.hasOwnProperty('@height'))
			{
				height = Number(fxgNode.@height.toString());
			}
			var referenceFormat:TextLayoutFormat = new TextLayoutFormat();
			var fxgAttributes:XMLList = fxgNode.attributes();
			var textLayoutSpace:Namespace = new Namespace(null, 'http://ns.adobe.com/textLayout/2008');
			var flowWrapper:XML = <TextFlow xmlns='http://ns.adobe.com/textLayout/2008' />;
			for each (var nodeAttribute:XML in fxgAttributes)
			{
				if (nodeAttribute.localName() && referenceFormat.hasOwnProperty(nodeAttribute.localName().toString()))
				{
					flowWrapper['@' + nodeAttribute.localName().toString()] = nodeAttribute.valueOf();
				}
			}
			var foundContentNodes:XMLList = fxgNode.*::content;
			for each (var contentNode:XML in foundContentNodes)
			{
				var contentKids:XMLList = contentNode.children();
				for each (var contentKid:XML in contentKids)
				{
					recursiveNamespaceReplace(contentKid, textLayoutSpace);
					flowWrapper.appendChild(contentKid);
				}
			}
			textFlow = TextFlowUtil.importFromXML(flowWrapper);
		}
		
		override public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshText:ExpressiveRichText = new ExpressiveRichText();
			transferDuplicateDisplayObjectProperties(this, freshText, namingTracker);
			transferDuplicateRichTextProperties(this, freshText);
			return freshText;
		}
		
		public static function transferDuplicateRichTextProperties(source:ExpressiveRichText, sink:ExpressiveRichText):void
		{
			sink.width = source.width;
			sink.height = source.height;
			sink.textFlow = source.textFlow ? source.textFlow.deepCopy() as TextFlow : null;
		}
		
		override public function getDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var drawingCode:String = "";
			if (targetFlex3)
			{
				// Use a TextField for the output display object code
				drawingCode += '\n' + getInstanceName() + '.wordWrap = true;';
				drawingCode += '\n' + getInstanceName() + '.selectable = false;';
				// TBD - implement auto-determination of appropriate width/height for vertical text
				var widthEstimate:Number = width;
				var heightEstimate:Number = height;
				if (isNaN(width) || width == 0 || isNaN(height) || height == 0)
				{
					if (textFlow)
					{
						var dummyContainer:Sprite = new Sprite();
						var dummyController:ContainerController = new ContainerController(dummyContainer, 100000, 100000);
						var flowCopy:TextFlow = textFlow.deepCopy() as TextFlow;
						flowCopy.flowComposer = new StandardFlowComposer();
						flowCopy.flowComposer.addController(dummyController);
						flowCopy.flowComposer.updateAllControllers();
						widthEstimate = Math.ceil(dummyController.tlf_internal::contentWidth);
						heightEstimate = Math.ceil(dummyController.tlf_internal::contentHeight);
					}
					else
					{
						widthEstimate = 100;
						heightEstimate = 100;
					}
				}
				drawingCode += '\n' + getInstanceName() + '.width = ' + widthEstimate + ';';
				drawingCode += '\n' + getInstanceName() + '.height = ' + heightEstimate + ';';
				if (textFlow)
				{
					var htmlData:String = TextConverter.export(textFlow, TextConverter.TEXT_FIELD_HTML_FORMAT, ConversionType.STRING_TYPE) as String;
					drawingCode += '\n' + getInstanceName() + ".htmlText = '" + htmlData + "';";
				}
			}
			else
			{
				// Use a TextFlow to generate TextLines on top of a text containing Sprite for the output display object code
				var containerControllerName:String = 'containerController' + trackingId.toString();
				var textFlowName:String = 'flow' + trackingId.toString();
				var localFlow:TextFlow = textFlow ? textFlow.deepCopy() as TextFlow : new TextFlow();
				drawingCode += '\nvar ' + containerControllerName + ':ContainerController = new ContainerController(' + getInstanceName() + ', ' + (width && !isNaN(width) ? width : 'NaN') + ', ' + (height && !isNaN(height) ? height : 'NaN') + ');';
				drawingCode += '\nvar ' + textFlowName + ':TextFlow = TextFlowUtil.importFromXML(' + TextFlowUtil.export(localFlow).toXMLString() + ');';
				drawingCode += '\n' + textFlowName + '.flowComposer.addController(' + containerControllerName + ');';
				drawingCode += '\n' + textFlowName + '.flowComposer.updateAllControllers();';
			}
			
			return drawingCode;
		}
		
		override public function getInstanceName():String
		{
			return explicitId ? explicitId : "text" + trackingId;
		}
		
		override public function getInstantiationAS3(targetFlex3:Boolean):String
		{
			if (targetFlex3)
			{
				return '\nvar ' + getInstanceName() + ':TextField = new TextField();';
			}
			else
			{
				return '\nvar ' + getInstanceName() + ':Sprite = new Sprite();';
			}
		}
		
		public static function recursiveNamespaceReplace(target:XML, namespace:Namespace):void
		{
			target.setNamespace(namespace);
			var kids:XMLList = target.children();
			for each (var kid:XML in kids)
			{
				recursiveNamespaceReplace(kid, namespace);
			}
		}
	}
}