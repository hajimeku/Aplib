package apollo.assetmanager.processproxy 
{
	import apollo.assetmanager.Asset;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class ProcessProxy 
	{
		protected var asset:Asset;

		public function ProcessProxy(_asset:Asset) 
		{
			this.asset = _asset;
		}
				
		protected function onProcessComplete():void {
			this.asset.finished();
		}
	}

}