package apollo.assetmanager 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class AssetLoadManager extends EventDispatcher
	{
		private var loadIds:Array;
		private var loadGroups:Array;
		
		private var currentAssetGroupLoading:AssetGroupLoader;
		
		public function AssetLoadManager() 
		{
			loadIds 	= [];
			loadGroups 	= [];
		}
		
		public function loadAssets(_assets:Array, _onComplete:Function, _onCompleteParams:Array, _altNames:Array, _prio:Number, _local:Boolean = false, _groupName:String = ""):AssetGroupLoader 
		{
			var assetLoader:AssetGroupLoader 	= new AssetGroupLoader(_assets, _altNames);
			assetLoader.onComplete				= _onComplete;
			assetLoader.onCompleteParams		= _onCompleteParams;
			assetLoader.id 						= this.getUniqueId();
			assetLoader.prio 					= _prio;
			assetLoader.local					= _local;
			assetLoader.groupName 				= (_groupName)?_groupName:assetLoader.id+"";
			
			loadGroups.push(assetLoader);
			
			processNextGroupInQueue();
			
			return assetLoader;
		}
		
		private function processNextGroupInQueue():void {
			if (this.currentAssetGroupLoading) return;
			
			currentAssetGroupLoading = this.sortLoadGroupsOnPrio(true);
			if (currentAssetGroupLoading) {
				currentAssetGroupLoading.startLoading();
				currentAssetGroupLoading.addEventListener(Event.COMPLETE, onGroupLoadComplete);
			}
		}
		
		private function onGroupLoadComplete(e:Event):void 
		{
			this.removeUniqueId(this.currentAssetGroupLoading.id);
		}
		
		public function sortLoadGroupsOnPrio(_getNext:Boolean = false):AssetGroupLoader {
			this.loadGroups.sortOn("prio", Array.NUMERIC);
			if (_getNext && this.loadGroups.length) {
				return this.loadGroups.shift();
			}
			return null;
		}
		
		private function removeUniqueId(_id:Number):void {
			var index:Number = this.loadIds.indexOf(currentAssetGroupLoading.id);
			if (index != -1) {
				this.loadIds.splice(index, 1);
			}
		}
		
		private function getUniqueId():Number 
		{
			var rn:Number = Math.floor(Math.random() * 1000000000);
			while (loadIds.indexOf(rn) != -1) {
				rn = Math.floor(Math.random() * 1000000000);
			}
			this.loadIds.push(rn);
			return rn;
		}
		
	}

}