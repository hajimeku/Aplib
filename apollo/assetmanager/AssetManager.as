package apollo.assetmanager 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class AssetManager 
	{
		private var assetLib:Dictionary = new Dictionary();
		private static var instance:AssetManager;
		
		public function AssetManager() 
		{
			
		}
		
		public function getTextureFromBitmap(_name:String):Texture {
			var texture:Texture = assetLib[_name + "texture"];
			if (!texture) {
				var bitmap:Bitmap = assetLib[_name];
				texture = Texture.fromBitmap(bitmap, true, false);
			}
			return texture;
		}
		
		public function getTextureFromAtf(_name:String, _scale:Number = 1, _mipMap:Boolean = false):Texture {
			var texture:Texture = assetLib[_name + "texture"];
			if (!texture) {
				var atf:ByteArray = assetLib[_name];
				texture = Texture.fromAtfData(atf, _scale, _mipMap);
			}
			return texture;
		}
		
		public function loadAssets(_assets:Array,_onComplete:Function, _params:Array = null, _altNames:Array = null, _local:Boolean = true):void {
			var assetLoader:AssetLoader = new AssetLoader(this, _assets, _onComplete, _params, _altNames, _local);
		}
		
		public static function getInstance():AssetManager
		{
			if (!instance) {
				instance = new AssetManager();
			}
			return instance;
		}
		
		public function getBitmap(_name:String):Bitmap {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: Bitmap can not be found");
			}
			return new Bitmap(assetLib[_name].bitmapData);
		}
		
		public function getAtf(_name:String):Bitmap {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: Bitmap can not be found");
			}
			return new Bitmap(assetLib[_name]);
		}
		
		public function getXml(_name:String):XML {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: xml can not be found");
			}
			return assetLib[_name];
		}
		
		public function checkAssetLoaded(_name:String):String 
		{
			if (!assetLib[_name]) return _name;
			return "";
		}
		
		public function setAsset(_name:String, _asset:*):void 
		{
			assetLib[_name] = _asset;
		}
	}

}