package  
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
		
		public function init(_stage:Stage, _class:Class):void {
			mStarling = new Starling(_class, _stage);
			mStarling.antiAliasing = 1;
			mStarling.start();
			mStarling.showStats = true;
		}
		
		public function getScreenBounds():Rectangle 
		{
			var bounds:Rectangle = new Rectangle(0, 0, mStarling.nativeStage.fullScreenWidth, mStarling.nativeStage.fullScreenHeight);
			return bounds;
		}
	}

}