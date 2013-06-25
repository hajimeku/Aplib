package apollo.assetmanager 
{
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
		
		override protected function onBaseAssetLoaded(e:AssetEvent):void 
		{
			var asset:Asset 		= e.asset;
			var bytes:ByteArray		= e.data as ByteArray;
			var dataType:String 	= asset.type;
			
			switch (dataType)
			{
				case "atf":
					asset.base = Texture.fromAtfData(bytes, 1, asset.finished);
					this.setAsset(asset.name, asset);
					return;
					break;
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
		
		public function getTextureFromBitmap(_name:String):Texture {
			var texture:Texture = assetLib[_name + "texture"];
			if (!texture) {
				var bitmap:Bitmap = assetLib[_name];
				texture = Texture.fromBitmap(bitmap, true, false);
				assetLib[_name + "texture"] = texture;
			}
			return texture;
		}
		
		public function getTextureFromAtf(_name:String, _scale:Number = 1, _mipMap:Boolean = false):Texture {
			var texture:Texture = assetLib[_name + "texture"];
			if (!texture) {
				var atf:ByteArray = assetLib[_name];
				texture = Texture.fromAtfData(atf, _scale);
				//texture = Texture.fromAtfData(atf, _scale, _mipMap);
				assetLib[_name + "texture"] = texture;
			}
			return texture;
		}
		
		public function getAtf(_name:String):Bitmap {
			if (!assetLib[_name]) {
				throw new Error("AssetManager: Bitmap can not be found");
			}
			return new Bitmap(assetLib[_name]);
		}
		
	}

}