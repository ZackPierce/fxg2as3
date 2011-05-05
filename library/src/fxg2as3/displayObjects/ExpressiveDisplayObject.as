package fxg2as3.displayObjects
{
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fxg2as3.CoordinateSpaceTransformableUtil;
	import fxg2as3.ICoordinateSpaceTransformable;
	import fxg2as3.IFXGReader;
	import fxg2as3.ISimpleAS3Writer;
	import fxg2as3.NamingTracker;
	import fxg2as3.filters.ExpressiveBevelFilter;
	import fxg2as3.filters.ExpressiveBlurFilter;
	import fxg2as3.filters.ExpressiveColorMatrixFilter;
	import fxg2as3.filters.ExpressiveDropShadowFilter;
	import fxg2as3.filters.ExpressiveGlowFilter;
	import fxg2as3.filters.ExpressiveGradientBevelFilter;
	import fxg2as3.filters.ExpressiveGradientGlowFilter;
	import fxg2as3.filters.IExpressiveFilter;
	import fxg2as3.graphics.ExpressiveColorTransform;
	
	import spark.core.MaskType;
	
	public class ExpressiveDisplayObject implements IFXGReader, ISimpleAS3Writer, ICoordinateSpaceTransformable
	{
		public var trackingId:uint = 0;
		
		[Bindable] public var x:Number = 0;
		[Bindable] public var y:Number = 0;
		[Bindable] public var scaleX:Number = 1;
		[Bindable] public var scaleY:Number = 1;
		[Bindable] public var rotation:Number = 0;
		[Bindable] public var matrix:Matrix;
		public var alpha:Number = 1;
		public var visible:Boolean = true;
		public var blendMode:String = BlendMode.NORMAL;
		public var explicitId:String = null;
		public var maskType:String = MaskType.CLIP; // Currently do not support MaskType.ALPHA and MaskType.LUMINOSITY - the latter requires PixelBender
		
		
		public var expressiveColorTransform:ExpressiveColorTransform;
		public var scale9Grid:Rectangle;
		public var filters:Vector.<IExpressiveFilter> = new Vector.<IExpressiveFilter>();
		public var mask:ExpressiveDisplayObject;
		
		private var supportedFilterClassNames:Array = ["BevelFilter", "ColorMatrixFilter", "DropShadowFilter", "GlowFilter", "GradientBevelFilter", "GradientGlowFilter"];
		
		public function ExpressiveDisplayObject()
		{
		}
		
		public function populateFromFXG(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			// Factored out parsing of x, y, scaleX, scaleY, rotation, and matrix since non-display-objects (like Gradients) also use these properties
			CoordinateSpaceTransformableUtil.populateCoordinateSpaceTransformableFromFXG(this, fxgNode, true);
			
			parseBaseDisplayObjectAttributes(fxgNode);
			parseColorTransform(fxgNode, namingTracker, library);
			parseFilters(fxgNode, namingTracker, library);
			parseMask(fxgNode, namingTracker, library);
		}
		
		public function parseColorTransform(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			var foundColorTransforms:XMLList = fxgNode.*::transform.*::Transform.*::colorTransform.*::ColorTransform;
			if (foundColorTransforms.length() < 1)
			{
				return;
			}
			var colorTransformNode:XML = foundColorTransforms[0] as XML;
			this.expressiveColorTransform = new ExpressiveColorTransform();
			this.expressiveColorTransform.populateFromFXG(fxgNode, namingTracker, library);
		}
		
		public function parseFilters(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			var foundFilterContainers:XMLList = fxgNode.*::filters;
			if (foundFilterContainers.length() < 1)
			{
				return;
			}
			var foundFilterNodes:XMLList = (foundFilterContainers[0] as XML).children();
			var localFilters:Vector.<IExpressiveFilter> = new Vector.<IExpressiveFilter>();
			for each(var filterNode:XML in foundFilterNodes)
			{
				var nodeName:String = filterNode.localName() ? filterNode.localName().toString() : null;
				if (!nodeName || nodeName == null || supportedFilterClassNames.indexOf(nodeName) < 0)
				{
					continue;
				}
				var expressiveFilter:IExpressiveFilter = null;
				switch (nodeName)
				{
					case "BevelFilter":
						expressiveFilter = new ExpressiveBevelFilter();
						break;
					case "BlurFilter":
						expressiveFilter = new ExpressiveBlurFilter();
						break;
					case "ColorMatrixFilter":
						expressiveFilter = new ExpressiveColorMatrixFilter();
						break;
					case "DropShadowFilter":
						expressiveFilter = new ExpressiveDropShadowFilter();
						break;
					case "GlowFilter":
						expressiveFilter = new ExpressiveGlowFilter();
						break;
					case "GradientBevelFilter":
						expressiveFilter = new ExpressiveGradientBevelFilter();
						break;
					case "GradientGlowFilter":
						expressiveFilter = new ExpressiveGradientGlowFilter();
						break;
				}
				if (expressiveFilter)
				{
					expressiveFilter.populateFromFXG(filterNode, namingTracker, library);
					localFilters.push(expressiveFilter);
				}
			}
			this.filters = localFilters;
		}
		
		public function parseMask(fxgNode:XML, namingTracker:NamingTracker, library:Dictionary):void
		{
			var foundMaskContainers:XMLList = fxgNode.*::mask;
			if (foundMaskContainers.length() > 0)
			{
				var maskContainer:XML = foundMaskContainers[0] as XML;
				var foundMaskDisplayObjects:XMLList = maskContainer.children();
				if (foundMaskDisplayObjects.length() > 0)
				{
					this.mask = ExpressiveDisplayObjectFactory.generateExpressiveDisplayObjectFromFXGNode(foundMaskDisplayObjects[0] as XML, namingTracker, library);
				}
			}
		}
		
		public function parseBaseDisplayObjectAttributes(fxgNode:XML):void
		{
			if (fxgNode.hasOwnProperty("@id"))
			{
				this.explicitId = fxgNode.@id.toString();
			}
			if (fxgNode.hasOwnProperty("@alpha"))
			{
				this.alpha = Number(fxgNode.@alpha.toString());
			}
			if (fxgNode.hasOwnProperty("@visible"))
			{
				this.visible = fxgNode.@visible.toString() == "true";
			}
			if (fxgNode.hasOwnProperty("@blendMode"))
			{
				this.blendMode = fxgNode.@blendMode.toString();
			}
			if (fxgNode.hasOwnProperty("@maskType"))
			{
				this.maskType = fxgNode.@maskType.toString();
			}
			
			// TBD - parse scale9 related attributes
		}
		
		public function clone(namingTracker:NamingTracker):ExpressiveDisplayObject
		{
			var freshCopy:ExpressiveDisplayObject = new ExpressiveDisplayObject();
			freshCopy.trackingId = namingTracker.getNextId();
			transferDuplicateDisplayObjectProperties(this, freshCopy, namingTracker);
			return freshCopy;
		}
		
		public static function transferDuplicateDisplayObjectProperties(source:ExpressiveDisplayObject, sink:ExpressiveDisplayObject, namingTracker:NamingTracker):void
		{
			sink.x = source.x;
			sink.y = source.y;
			sink.scaleX = source.scaleX;
			sink.scaleY = source.scaleY;
			sink.alpha = source.alpha;
			sink.visible = source.visible;
			sink.blendMode = source.blendMode;
			sink.explicitId = source.explicitId;
			sink.matrix = source.matrix ? source.matrix.clone() : null;
			sink.expressiveColorTransform = source.expressiveColorTransform ? source.expressiveColorTransform.expressiveClone() : null;
			sink.scale9Grid = source.scale9Grid ? source.scale9Grid.clone() : null;
			sink.mask = source.mask ? source.mask.clone(namingTracker) : null;
			if (source.filters)
			{
				var sinkFilters:Vector.<IExpressiveFilter> = new Vector.<IExpressiveFilter>();
				for each (var expressiveFilter:IExpressiveFilter in source.filters)
				{
					sinkFilters.push(expressiveFilter.cloneFilter());
				}
				sink.filters = sinkFilters;
			}
			else
			{
				sink.filters = new Vector.<IExpressiveFilter>();
			}
		}
		
		public function getInstanceName():String
		{
			return explicitId ? explicitId : "displayObject" + trackingId;
		}
		
		public function getInstantiationAS3(targetFlex3:Boolean):String
		{
			// This should always be overridden by children;
			return '\nvar ' + getInstanceName() + ":DisplayObject = new DisplayObject();"; // DisplayObjects are informally abstract, and should not be instantiated in practice
		}
		
		public function getCoordinateTransformationAS3(targetFlex3:Boolean, useVectorNotation:Boolean):String
		{
			if (this.matrix)
			{
				return '\n' + getInstanceName() + '.transform.matrix = ' + CoordinateSpaceTransformableUtil.matrixToAS3String(this.matrix) + ';';
			}
			else
			{
				var out:String = "";
				if (this.x != 0)
				{
					out += "\n" + getInstanceName() + ".x = " + this.x + ";";
				}
				if (this.y != 0)
				{
					out += "\n" + getInstanceName() + ".y = " + this.y + ";";
				}
				if (this.scaleX != 1)
				{
					out += "\n" + getInstanceName() + ".scaleX = " + this.scaleX + ";";
				}
				if (this.scaleY != 1)
				{
					out += "\n" + getInstanceName() + ".scaleY = " + this.scaleY + ";";
				}
				if (this.rotation != 0)
				{
					out += "\n" + getInstanceName() + ".rotation = " + this.rotation + ";";
				}
				return out;
			}
		}
		
		public function getColorTransformationAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var out:String = "";
			if (this.expressiveColorTransform)
			{
				out += '\n' + getInstanceName() + '.transform.colorTransform = ' + this.expressiveColorTransform.toAS3String(targetFlex3, useVectorNotation, numericPrintingPrecision);
			}
			
			return out;
		}
		
		public function getDisplayLayerAS3(targetFlex3:Boolean, useVectorNotation:Boolean):String
		{
			var displayLayerCode:String = '';
			if (!visible)
			{
				displayLayerCode += '\n' + getInstanceName() + '.visible = false;';
			}
			if (alpha != 1)
			{
				displayLayerCode += '\n' + getInstanceName() + '.alpha = ' + alpha + ';';
			}
			if (blendMode != BlendMode.NORMAL)
			{
				displayLayerCode += '\n' + getInstanceName() + '.blendMode = "' + blendMode + '";'; 
			}
			// TBD - scale9 code
			return displayLayerCode;
		}
		
		public function getFilterAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var out:String = "";
			if (filters.length < 1)
			{
				return out;
			}
			else
			{
				out += '\n' + getInstanceName() + '.filters = [';
			}
			for (var i:int = 0; i < filters.length; i++)
			{
				var expressiveFilter:IExpressiveFilter = filters[i] as IExpressiveFilter;
				out += '\n    ' + expressiveFilter.toAS3String(targetFlex3, useVectorNotation, numericPrintingPrecision);
				if (i < filters.length - 1)
				{
					out += ',';
				}
			}
			out += '];';
			return out;
		}
		
		public function getMaskInstantiationAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			if (this.mask)
			{
				return "\n" + this.mask.toAS3String(targetFlex3, useVectorNotation, numericPrintingPrecision);
			}
			else
			{
				return "";
			}
			
			var out:String = "\n";
			return out;
		}
		
		public function getDrawingAS3(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			return ""; // Meaningfully overridden in children to draw their custom content
		}
		
		public function toAS3String(targetFlex3:Boolean, useVectorNotation:Boolean, numericPrintingPrecision:int):String
		{
			var out:String = "";
			out += getInstantiationAS3(targetFlex3);
			out += getCoordinateTransformationAS3(targetFlex3, useVectorNotation);
			out += getColorTransformationAS3(targetFlex3, useVectorNotation, numericPrintingPrecision);
			out += getDisplayLayerAS3(targetFlex3, useVectorNotation);
			out += getDrawingAS3(targetFlex3, useVectorNotation, numericPrintingPrecision);
			out += getFilterAS3(targetFlex3, useVectorNotation, numericPrintingPrecision);
			out += getMaskInstantiationAS3(targetFlex3, useVectorNotation, numericPrintingPrecision);
			return out;
		}
	}
}