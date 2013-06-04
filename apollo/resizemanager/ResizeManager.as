package apollo.resizemanager 
{
	import debugger.Debug;
	import flash.display.Stage;
	import flash.events.Event;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class ResizeManager 
	{
		private static var instance:ResizeManager;
		
		private var regDisplayObjects:Array = [];
		public var orriStageWidth:Number = 0;
		public var orriStageHeight:Number = 0;
		private var stage:*;
		
		public static const CENTER:String = "center";
		public static const TOP:String = "top";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		
		//HANDLERS
		private var debug:Debug = Debug.getInstance();
		
		
		public function ResizeManager(_stage:*) 
		{
			this.stage = _stage;
			this.stage.addEventListener(Event.RESIZE , onStageResize);
		}
		
		private function onStageResize(e:Event):void
		{
			trace("onStageResize");
			var l:Number = regDisplayObjects.length;
			for (var i:int = 0; i < l; i++)
			{
				var reqObj:Object = regDisplayObjects[i];
				this.alignDisplayObject(reqObj);
			}
		}
		
		public static function getInstance(_stage:* = null):ResizeManager {
			if (!instance && !_stage) {
				throw new Error("No stage init");
			}
			if (!instance) {
				instance = new ResizeManager(_stage);
			}
			return instance;
		}
		
		public function registerDisplayObject(_displayObject:DisplayObject, _align:String, _offsetX:Number = 0, _offsetY:Number = 0, _offsetXPerc:Number = 0, _offsetYPerc:Number = 0):void {
			var reqObj:Object = { align:_align, display:_displayObject, offsetX:_offsetX, offsetY:_offsetY, offsetXPerc:_offsetXPerc, offsetYPerc:_offsetYPerc };
			regDisplayObjects.push( reqObj );
			this.alignDisplayObject(reqObj);
		}
		
		private function alignDisplayObject(_reqObj:Object):void 
		{
			var displayObject:DisplayObject = _reqObj.display;
			var align:String				= _reqObj.align;
			var spillbounds:Object 			= this.getFluidSpillBounds();
			var x:Number 					= displayObject.x;
			var y:Number 					= displayObject.y;
			trace(align);
			switch(align) {
				case "center":
					x = (this.stage.stageWidth * 0.5) - (spillbounds.x * 0.5);
					y = (this.stage.stageHeight * 0.5) - (spillbounds.y * 0.5);
					x -= (displayObject.width *0.5);
					y -= (displayObject.height * 0.5);
				break;
				case "right":
					x =  this.stage.stageWidth - (spillbounds.x * 0.5);
					x -= displayObject.width
					trace(x);
				break;
				case "left":
					x = (spillbounds.x * 0.5);
					x += displayObject.width
				break;
				case "top":
					y = -(spillbounds.y * 0.5);
					y += displayObject.height
				break;
				case "bottom":
					y =  this.stage.stageHeight;
					y -= displayObject.height
				break;
			}
			
			displayObject.x = (Math.floor(x) + _reqObj.offsetX);
			displayObject.y = (Math.floor(y) + _reqObj.offsetY);
		}
		
		public function getFluidSpillBounds():Object {
			var bounds:Object = { };
			bounds.x = this.stage.stageWidth - this.orriStageWidth;
			bounds.y = this.stage.stageHeight - this.orriStageHeight;
			return bounds;
		}
		
		public function unregisterDisplayObject(_displayObject:DisplayObject):void {
			var l:Number = regDisplayObjects.length;
			for (var i:int = 0; i < l; i++) 
			{
				var obj:Object = regDisplayObjects[i];
				if (_displayObject == obj.display) {
					//removing the display item from resize manager
					regDisplayObjects.splice(i, 1);
					return;
				}
			}
		}
	}

}