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
	public class ProcessDefault extends ProcessProxy 
	{
		
		public function ProcessDefault(_asset:Asset, _bytes:ByteArray, _securityDomain:SecurityDomain = null, _applicationDomain:ApplicationDomain = null) 
		{
			super(_asset);
			var loader:Loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext(false, _applicationDomain, _securityDomain);
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDefauldAssetLoaded);
			loader.loadBytes(_bytes, loaderContext);
		}
		
		public function onDefauldAssetLoaded(e:Event):void 
		{
			this.asset.base = e.target.content;
			onProcessComplete();
		}
	}

}