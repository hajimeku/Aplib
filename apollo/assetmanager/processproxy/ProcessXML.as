package apollo.assetmanager.processproxy 
{
	import apollo.assetmanager.Asset;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class ProcessXML extends ProcessProxy 
	{
		
		public function ProcessXML(_asset:Asset, _byteArray:ByteArray) 
		{
			super(_asset);
			this.asset.base = new XML(_byteArray);
			this.onProcessComplete();
		}
	}

}