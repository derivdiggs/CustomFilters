
package com.baseclasses.events
{
	
	import flash.events.*;

	public class CustomEvent2 extends Event 
	{
		
		public var evtObj:Object;
		
		public function CustomEvent2(event:String, _evtObj:Object)
		{
			super(event, true, true);
			evtObj = _evtObj;
		//trace("CUSTOM EVENT IS BEING DISPATCHED: " + evtObj);
		}
	}
}
