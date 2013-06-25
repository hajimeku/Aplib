package apollo.assetmanager 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class AssetManager extends EventDispatcher
	{
		//atlas variables, always used
		private var assetLib:Dictionary;
		private var assetLoadManager:AssetLoadManager;
		
		//singleton variables
		private static var instance:AssetManager; 
		private static var allowInstance:Boolean = false;
		//---
		
		private var local:Boolean = false;
		
		public function AssetManager() 
		{
			if (!allowInstance) {
				throw new Error("This is a singleton, please use 'getInstance()'");
			}
			assetLib 			= new Dictionary();
			assetLoadManager 	= new AssetLoadManager();
		}
		
		//TODO: Implement asset proxy process
		protected function onBaseAssetLoaded(e:AssetEvent):void 
		{
			var asset:Asset 		= e.asset;
			var bytes:ByteArray		= e.data as ByteArray;
			var dataType:String 	= asset.type;
			
			switch (dataType)
			{
				case "fnt":
				case "xml":
					asset.base = new XML(bytes);
					break;
				case "mp3":
					var sound:Sound = new Sound();
					sound.loadCompressedDataFromByteArray(bytes, bytes.length);
					asset.base = sound;
					break;
				default:
					var loader:Loader = new Loader();
					var securityDomain:* = (asset.group.local)?null:SecurityDomain.currentDomain;
					var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, securityDomain);
					loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, asset.onDefauldAssetLoaded);
					loader.loadBytes(bytes, loaderContext);
					return;
					break;
			}
			asset.finished();
		}
		
		private function onAssetComplete(e:AssetEvent):void 
		{
			
		}
		
		private function onAssetGroupComplete(e:AssetEvent):void 
		{
			this.dispatchEvent(e);
		}
		
		public function loadAssets(_assets:Array, _onComplete:Function, _onCompleteParams:Array = null, _altNames:Array = null, _prio:Number = 10, _local:Boolean = false, _groupName:String = ""):void {
			var local:Boolean = (!_local)?this.local:_local;
			var assets:Array 		= _assets;
			var assetAltNames:Array = _altNames;
			
			var l:Number = assets.length;
			for (var i:int = l-1; i >= 0 ; i--) 
			{
				var assetName:String = assets[i];
				if (assetAltNames && assetAltNames.length-1 >= i && assetAltNames[i]) {
					assetName = assetAltNames[i];
					if (this.checkAssetLoaded(assetName)) {
						assetAltNames.splice(i, 1);
						assets.splice(i, 1);
					}
				}else {
					if (this.checkAssetLoaded(assetName)) {
						assets.splice(i, 1);
					}
				}
			}
			
			var group:AssetGroupLoader = assetLoadManager.loadAssets(assets, _onComplete, _onCompleteParams, assetAltNames, _prio, local, _groupName);
			group.addEventListener(AssetEvent.BASE_ASSET_LOADED, onBaseAssetLoaded);
			group.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			group.addEventListener(AssetEvent.ASSET_GROUP_COMPLETE, onAssetGroupComplete);
		}
		
		public static function getInstance():AssetManager
		{
			if (!instance) {
				allowInstance = true;
				instance = new AssetManager();
				allowInstance = false;
			}
			return instance;
		}
		
		public function getBitmap(_name:String):Bitmap {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: Bitmap can not be found");
			}
			return new Bitmap(assetLib[_name].bitmapData);
		}
		
		public function getXml(_name:String):XML {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: xml can not be found");
			}
			return assetLib[_name];
		}
		
		public function checkAssetLoaded(_name:String):String 
		{
			if (assetLib[_name]) return _name;
			return "";
		}
		
		public function setAsset(_name:String, _asset:Asset):void 
		{
			assetLib[_name] = _asset;
		}
	}

}