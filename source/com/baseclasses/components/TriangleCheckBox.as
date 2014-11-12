package com.sellproto.version1.view.components
{

import flash.display.*;
import flash.utils.*;
import flash.events.*;
import gs.*;
import gs.easing.*;
import com.sellproto.version1.events.*;

	public class TriangleCheckBox extends MovieClip
	{
		
		private var _id:int;
		private var _rowId:String;
		private var _label:String;
		private var _isSelected:Boolean = false;
        
        public function TriangleCheckBox()
        {
			//trace("TriangleCheckBox()");
        	super();
        }

		public function setTriCheckBox(id:int, rowId:String , label:String):void
		{
			addEventListener(MouseEvent.CLICK, click_handler);
			addEventListener(MouseEvent.MOUSE_OVER, over_handler);
			addEventListener(MouseEvent.MOUSE_OUT, out_handler);
			buttonMode = true;
			mouseEnabled = true;
			useHandCursor = true;
			
			_id = id-1;
			_rowId = rowId;
			_label = label;
			_label_dt.text = _label;
		}
		
		public function boxDeactivate():void
		{
			removeEventListener(MouseEvent.CLICK, click_handler);
			removeEventListener(MouseEvent.MOUSE_OVER, over_handler);
			removeEventListener(MouseEvent.MOUSE_OUT, out_handler);
			buttonMode = false;
			mouseEnabled = false;
			useHandCursor = false;
		}
		
		public function boxActivate():void
		{
			addEventListener(MouseEvent.CLICK, click_handler);
			addEventListener(MouseEvent.MOUSE_OVER, over_handler);
			addEventListener(MouseEvent.MOUSE_OUT, out_handler);
			buttonMode = true;
			mouseEnabled = true;
			useHandCursor = true;
		}
		public function setActive(boo:Boolean)
		{
			if(boo)
			{
				TweenMax.to(this._fill, .5, {alpha:.8, ease:Quad.easeOut});
				_isSelected = true;
			}
			else
			{
				TweenMax.to(this._fill, .3, {alpha:0, ease:Quad.easeOut});
				_isSelected = false;
				
				
			}
		}
		
		private function over_handler(event:MouseEvent):void
		{
			TweenMax.to(_bk, .5, {glowFilter:{color:0x8989F5, alpha:1, blurX:20, blurY:20}});	
		}
		
		private function out_handler(event:MouseEvent):void
		{
			TweenMax.to(_bk, .5, {glowFilter:{color:0x8989F5, alpha:0, blurX:0, blurY:0}});
		}
		
		private function click_handler(event:MouseEvent):void
		{
			dispatchEvent(new CheckBoxEvent(CheckBoxEvent.TOGGLE, _rowId, _id, _isSelected));
		}
	}
}

