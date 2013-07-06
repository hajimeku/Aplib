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
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class StarlingAssetManager extends AssetManager
	{
		
		public function StarlingAssetManager() 
		{
			
		}
		
		override function onBaseAssetLoaded(e:AssetEvent):void 
		{
			var asset:Asset 				= e.asset;
			var bytes:ByteArray				= e.data as ByteArray;
			var dataType:String 			= asset.type;
			var processProxy:ProcessProxy;
			var securityDomain:*;
			
			switch (dataType)
			{
				case "png":
					securityDomain = (asset.group.local)?null:SecurityDomain.currentDomain;
					processProxy = new ProcessTextureBTM(asset, bytes, securityDomain, ApplicationDomain.currentDomain);
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
					securityDomain = (asset.group.local)?null:SecurityDomain.currentDomain;
					processProxy = new ProcessDefault(asset, bytes, securityDomain, ApplicationDomain.currentDomain); 
					break;
			}
		}
		
		public function getTextureFromBitmap(_name:String):Texture {
			var texture:Texture = assetLib[_name];
			return texture;
		}
		
		public function getTextureFromAtf(_name:String, _scale:Number = 1, _mipMap:Boolean = false):Texture {
			var texture:Texture = assetLib[_name];
			return texture;
		}
		
		public function getAtf(_name:String):Bitmap {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: ATF can not be found");
			}
			return new Bitmap(assetLib[_name]);
		}
		
	}

}