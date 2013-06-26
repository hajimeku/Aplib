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
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class ProcessSound extends ProcessProxy 
	{
		
		public function ProcessSound(_asset:Asset, _byteArray:ByteArray) 
		{
			super(_asset);
			var sound:Sound = new Sound();
			sound.loadCompressedDataFromByteArray(_byteArray, _byteArray.length);
			this.asset.base = sound;
			
			onProcessComplete();
		}
		
	}

}