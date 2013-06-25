package apollo.assetmanager 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class AssetEvent extends Event 
	{
		public static const BASE_ASSET_LOADED:String 	= "onBaseAssetComplete";
		public static const ASSET_COMPLETE:String		= "onAssetComplete";
		public static const ASSET_GROUP_COMPLETE:String = "onAssetGroupComplete";
		
		private var _data:*;
		private var _asset:Asset;
		
		public function AssetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new AssetEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AssetEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get data():*
		{
			return _data;
		}
		
		public function set data(value:*):void 
		{
			_data = value;
		}

		public function get asset():Asset 
		{
			return _asset;
		}
		
		public function set asset(value:Asset):void 
		{
			_asset = value;
		}
		
	}
	
}