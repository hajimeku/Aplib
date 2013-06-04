package apollo.communicator 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.Responder;
	/**
	 * ...
	 * @author Apollo Meijer
	 */
	public class PhpCommunicator extends MovieClip
	{
		private var responder:Responder;
		private var callBack:Function;
		
		public static var FINISHED_CALL:String = "finishedCall";
		
		public function PhpCommunicator( _method:String,_callback:Function, _netConnection:NetConnection, _params:*) 
		{
			responder = new Responder(onResult, onError);
			callBack = _callback;
			_netConnection.call(_method, responder,_params);
		}
		
		public function onResult(e:Object):void {
			callBack.apply(null,[e]);
			this.dispatchEvent(new Event(FINISHED_CALL));
		}
		
		public function onError(e:Object):void {
			callBack.apply(null, [{error:"Call did not work"}]);
			this.dispatchEvent(new Event(FINISHED_CALL));
		}
		
		public function destroy():void {
			responder = null;
			callBack = null;
		}
	}

}