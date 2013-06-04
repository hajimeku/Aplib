package apollo.mystage 
{
	import flash.utils.Dictionary;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class MyStage extends Sprite
	{
		public static var instance:MyStage;
		public static var initiated:Boolean;
		
		private var layers:Dictionary;
		
		public function MyStage()
		{
			
		}
		
		
		public static function getInstance():MyStage {
			if (!instance) {
				instance = new MyStage();
			}
			return instance;
		}
		
		public function initStageList(_layers:Array):void {
			if (initiated) return;
			layers = new Dictionary();
			var l:Number = _layers.length;
			for (var i:int = 0; i < l; i++) 
			{
				var layer:Object = _layers[i];
				var mc:Sprite = new Sprite();
				mc.name = layer.name;
				layers[layer.name] = mc;
				this.addChild(mc);
			}
			
			initiated = true;
		}
		
		public function getLayer(_name:String):Sprite {
			if (!initiated) {
				throw new Error("MyStage must first be initiated");
			}
			if (!layers[_name]) {
				throw new Error("Layer doese not exist!");
			}
			return layers[_name];
		}
	}

}