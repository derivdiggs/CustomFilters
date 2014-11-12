/*
*** a basic button that takes an id which it dispatches
*/

package com.ddiggs.transitions.view
{
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;
	import com.ddiggs.transitions.events.CustomEvent;

	public class BasicButton extends MovieClip
	{
		private var _id:int; // passed in holds the buttons id and is dispatched on click
		private var _bk:MovieClip; // a MovieClip that is embeded within the button that is the buttons background
        
        public function BasicButton()
        {
			trace("BasicButton()");
        	super();
        }
		
		public function setButton(id:int):void
		{
			_id = id;
			
			addEventListener(MouseEvent.CLICK, click_handler);
			addEventListener(MouseEvent.MOUSE_OVER, over_handler);
			addEventListener(MouseEvent.MOUSE_OUT, out_handler);
			
			buttonMode = true;
			mouseEnabled = true;
			useHandCursor = true;
		}
		
		/*
		*** make button glow on rollover
		*/
			
		private function over_handler(event:MouseEvent):void
		{
			TweenMax.to(this, .2, {glowFilter:{color:0x8989F5, alpha:1, blurX:20, blurY:20}, alpha:1});
		}
		
		/*
		*** remove button glow on rollout
		*/
			
		private function out_handler(event:MouseEvent):void
		{
			TweenMax.to(this, .4, {glowFilter:{color:0x8989F5, alpha:0, blurX:0, blurY:0}, alpha:.9});
		}
		
		/*
		*** dispatch NavEvent with 'id' as event object on click
		*/
			
		private function click_handler(event:MouseEvent):void
		{
			trace("hit a button id: " + _id);
			dispatchEvent(new CustomEvent("NavEvent", {id:_id}));
		}
	}
}

