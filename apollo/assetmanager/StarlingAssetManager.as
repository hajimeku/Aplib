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

	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class StarlingAssetManager extends AssetManager
	{
		//singleton variables
		private static var instance:StarlingAssetManager; 
		private static var allowInstance:Boolean = false;
		//---
		public function StarlingAssetManager() 
		{
			
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
		
		override function onBaseAssetLoaded(e:AssetEvent):void 
		{
			var asset:Asset 				= e.asset;
			var bytes:ByteArray				= e.data as ByteArray;
			var dataType:String 			= asset.type;
			var processProxy:ProcessProxy;
			
			switch (dataType)
			{
				case "png":
					processProxy = new ProcessTextureBTM(asset, bytes, ApplicationDomain.currentDomain);
					asset.addEventListener(Event.COMPLETE, onPngLoadedComplete);
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
			var target:Asset = event.currentTarget;
			this.setAsset(target.name+"_bitmapdata", target.subbase);
		}
		
		public function getBitmapData(_name:String):BitmapData {
			if (!assetLib[_name +" _bitmapData"]) {
				throw new Error("AssetManager: BitmapData can not be found");
			}
			return (assetLib[_name +" _bitmapData"]);
		}
		
		public function getTexture(_name):Texture{
			if (!assetLib[_name]) {
				throw new Error("AssetManager: Texture can not be found");
			}
			return (assetLib[_name]);
		}

		public function getAtf(_name:String):ByteArray {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: ATF can not be found");
			}
			return new Bitmap(assetLib[_name]);
		}
		
	}

}