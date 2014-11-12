/*
*** a simple event that bubbles and takes in a generic object
*/

package com.ddiggs.transitions.events
{
	
	import flash.events.*;

	public class CustomEvent extends Event 
	{
		
		public var evtObj:Object; // populate when event is designated to pass data along with event
		
		public function CustomEvent(event:String, _evtObj:Object)
		{
			super(event, true, true);
			evtObj = _evtObj;
		
		}
	}
}
