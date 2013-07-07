package apollo.assetmanager 
{
	import apollo.assetmanager.processproxy.ProcessDefault;
	import apollo.assetmanager.processproxy.ProcessProxy;
	import apollo.assetmanager.processproxy.ProcessSound;
	import apollo.assetmanager.processproxy.ProcessTextureATF;
	import apollo.assetmanager.processproxy.ProcessTextureBTM;
	import apollo.assetmanager.processproxy.ProcessXML;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class StarlingAssetManager extends AssetManagerBase
	{
		//singleton variables
		private static var instance:StarlingAssetManager; 
		private static var allowInstance:Boolean = false;
		//---
		public function StarlingAssetManager() 
		{
			super();
			if (!allowInstance) {
				throw new Error("This is a singleton, please use 'getInstance()'");
			}
		}
		
		public static function getInstance():StarlingAssetManager
		{
			if (!instance) {
				allowInstance = true;
				instance = new StarlingAssetManager();
				allowInstance = false;
			}
			return instance;
		}
		
		override public function onBaseAssetLoaded(e:AssetEvent):void 
		{
			var asset:Asset 				= e.asset;
			var bytes:ByteArray				= e.data as ByteArray;
			var dataType:String 			= asset.type;
			var processProxy:ProcessProxy;
			
			switch (dataType)
			{
				case "png":
					processProxy = new ProcessTextureBTM(asset, bytes, ApplicationDomain.currentDomain);
					asset.addEventListener(Event.COMPLETE, onPngLoadedComplete, false, 20);
					break;
				case "atf":
					processProxy = new ProcessTextureATF(asset, bytes);
					break;
				case "fnt":
				case "xml":
					processProxy = new ProcessXML(asset , bytes);
					break;
				case "mp3":
					processProxy = new ProcessSound(asset , bytes);
					break;
				default:
					processProxy = new ProcessDefault(asset, bytes, ApplicationDomain.currentDomain); 
					break;
			}
		}
		
		public function onPngLoadedComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("COMPLETE");
			var asset:Asset = event.currentTarget as Asset;
			this.setAsset(asset.name+"_bitmapData", asset.subbase.bitmapData);
		}
		
		public function getBitmapData(_name:String):BitmapData {
			if (!this.assetLib[_name +"_bitmapData"]) {
				throw new Error("AssetManager: BitmapData can not be found");
			}
			return (this.assetLib[_name +"_bitmapData"]);
		}
		
		public function getTexture(_name:String):Texture{
			if (!this.assetLib[_name]) {
				throw new Error("AssetManager: Texture can not be found");
			}
			return (this.assetLib[_name]);
		}

		public function getAtf(_name:String):ByteArray {
			if (!this.assetLib[_name]) {
				throw new Error("AssetManager: ATF can not be found");
			}
			return this.assetLib[_name];
		}
		
	}

}