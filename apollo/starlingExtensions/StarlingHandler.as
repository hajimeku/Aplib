package apollo.starlingExtensions
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class StarlingHandler extends Sprite
	{
		private static var instance:StarlingHandler;
		public var mStarling:Starling;
		public var mAppScale:Number;
		
		public function StarlingHandler() 
		{
			
		}
		
		public static function getInstance():StarlingHandler {
			if (!instance) {
				instance = new StarlingHandler();
			}
			return instance;
		}
		
		public function init(_stage:Stage, _class:Class, _showStats:Boolean = true, _resize:Boolean = true):void {
			mStarling = new Starling(_class, _stage);
			mStarling.antiAliasing = 1;
			mStarling.start();
			mStarling.showStats = _showStats;
			
			if (_resize) {
				_stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			}
		}
		

		private function stage_resizeHandler(event:Event = null):void
		{
			this.mStarling.stage.stageWidth = this.mStarling.nativeStage.stageWidth;
			this.mStarling.stage.stageHeight = this.mStarling.nativeStage.stageHeight;

			const viewPort:Rectangle = this.mStarling.viewPort;
			viewPort.width = this.mStarling.nativeStage.stageWidth;
			viewPort.height = this.mStarling.nativeStage.stageHeight;
			try
			{
				this.mStarling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}


		
		public function getScreenBounds():Rectangle 
		{
			var bounds:Rectangle = new Rectangle(0, 0, mStarling.nativeStage.fullScreenWidth, mStarling.nativeStage.fullScreenHeight);
			return bounds;
		}
	}

}