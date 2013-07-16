package apollo.assetmanager.processproxy 
{
	import apollo.assetmanager.Asset;
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
	public class ProcessTextureATF extends ProcessProxy 
	{
		
		public function ProcessTextureATF(_asset:Asset, _byteArray:ByteArray, _scale:Number = 1, _mipMaps:Boolean = false) 
		{
			super(_asset);
			var texture:Texture = Texture.fromAtfData(_byteArray, _scale, _mipMaps, onProcessComplete);
			texture.root.onRestore = function():void {
				texture.root.uploadAtfData(_byteArray);
			}
		}
		
	}

}