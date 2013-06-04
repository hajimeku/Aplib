package debugger 
{
	import apollo.mystage.MyStage;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class Debug extends Sprite
	{
		static private var instance:Debug;
		private var debugTextfield:TextField;
		private var contentHolder:Sprite;
		private var keysPressed:Dictionary = new Dictionary();
		public var token:String = "2ad34a26cb7644dadd16f29225e7a86ffbd7939d674997cdb4692d34de8633c4d8f979595a17e058fe9cd2c662a0b203";
		
		public function Debug() 
		{
			debugTextfield = new TextField(1000, 800, "", "Arial", 12, 0xC60000 ,true);
			debugTextfield.hAlign = "left";
			debugTextfield.vAlign = "top";
			debugTextfield.x = 50;
			debugTextfield.touchable = false;
			this.addChild(debugTextfield);
			
			MyStage.getInstance().getLayer("debug").addChild(this);
			
			StarlingHandler.getInstance().mStarling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			StarlingHandler.getInstance().mStarling.nativeStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			keysPressed[e.keyCode] = false;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (keysPressed[e.keyCode]) return;
			keysPressed[e.keyCode] = true;
			
			//shift t
			if (keysPressed[84] && keysPressed[16]) {
				//set token to clipboard
				System.setClipboard(ApplicationSettings.token);
				doTrace("Token set to clipboard");
			}
		}
		
		public function doTrace(_obj:*):void {
			debugTextfield.text += "- "+String(_obj)+"\n";
		}
		
		public static function getInstance():Debug {
			if (!instance) {
				instance = new Debug();
			}
			return instance;
		}
	}

}