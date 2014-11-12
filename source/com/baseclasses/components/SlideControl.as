package com.sellproto.version1.view.components
{
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;
	import com.sellproto.version1.events.*;

	public class SlideControl extends MovieClip
	{
        private var _offsetX:Number;
		private var _offsetY:Number;
		private var _minX:Number;
		private var _maxX:Number;
		private var _shouldDrag = false;
		private var square:Sprite = new Sprite();
		private var _thumbWidth:Number;
		private var _ogSquareY:Number;
		private var _minNumber:Number;
		private var _maxNumber:Number;
		private var _defaultNumber:Number;
		private var _trackLength:Number;
		
        public function SlideControl()
        {
			trace("GridSizeControl()");
        	super();
        }
		
		public function setSlideControl(trackLength:Number, minNumber:Number, maxNumber:Number, defaultNumber):void
		{
			_minNumber = minNumber;
			_maxNumber = maxNumber;
			_trackLength = trackLength;
			_min_dt.text = _minNumber.toString();
			_max_dt.text = (_maxNumber + _minNumber).toString();
			_defaultNumber = defaultNumber;
			initAll();
		}
		
		private function initAll():void
		{
			_track.width = _trackLength;
			
			_thumbWidth = _thumb._bk.width;
			_minX = 0;
			_maxX = _track.width - _thumbWidth;
			
		//	var tmpNewX:Number = (_defaultNumber *  ( _maxNumber/_maxX ));

			var tmpNewX:Number = (((_defaultNumber - _minNumber)* _maxX ) / _maxNumber);
			//var tmpNewX:Number = Math.ceil((((_defaultNumber - _minNumber)* _maxX ) / _maxNumber));
			trace("_defaultNumber: " + _defaultNumber + " _maxX: " + _maxX+ " _trackLength: "+ _trackLength +" _maxNumber: " + _maxNumber+ " _minNumber: " + _minNumber + " tmpNewX: " + tmpNewX);
			
			_thumb.x = tmpNewX;
			
			updateDT();
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			_thumb.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			_thumb.addEventListener(MouseEvent.MOUSE_OUT, stopTrack);
			_thumb._bk.addEventListener(MouseEvent.MOUSE_DOWN, over_handler);
			_thumb._bk.addEventListener(MouseEvent.MOUSE_OVER, over_handler);
			_thumb._bk.addEventListener(MouseEvent.MOUSE_OUT, out_handler);
			_thumb._bk.buttonMode = true;
			_thumb._bk.mouseEnabled = true;
			_thumb._bk.useHandCursor = true;
			
			//create bigger handle for thumb for usability
			square.graphics.beginFill(0xFF0000);
			square.graphics.drawRect(-50, -10, 120, 80);
			square.alpha = 0;
			_thumb.addChild(square);
		}
		
		private function updateDT():void
		{
			var tmpSize:Number = Math.ceil(((_thumb.x - _minX) * _maxNumber / _maxX - _minX) + _minNumber);
			trace("min x: " + _minX);
			_thumb._size_dt.text = tmpSize;
		}
		
		private function startDragging(event:MouseEvent):void
		{
		    _offsetX = event.stageX - _thumb.x;
		    _offsetY = event.stageY - _thumb.y;
		    stage.addEventListener(MouseEvent.MOUSE_MOVE, drag_thumb);
			_shouldDrag = true;
		}

		private function stopDragging(event:MouseEvent):void
		{
			_shouldDrag = false;
		    stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag_thumb);
		}
		
		private function stopTrack(event:MouseEvent):void
		{
			_shouldDrag = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag_thumb);
		}

		private function drag_thumb(event:MouseEvent):void
		{
			if(_shouldDrag)
			{
				var tmpX:Number = event.stageX - _offsetX;
				if(tmpX >= (_minX-.5) && tmpX < _maxX)
				{
					_thumb.x = tmpX;
					trace("good tmpX: " + tmpX);
					updateDT();
				}
				else
				{
					trace("bad tmpX: " + tmpX);
				}
			    event.updateAfterEvent();
				var passNumber:Number = Math.ceil(((_thumb.x - _minX) * _maxNumber / _maxX - _minX) + _minNumber);
				dispatchEvent(new SlideControlEvent(SlideControlEvent.CHANGENUMBER, passNumber));
			}	
		}
		
		private function out_handler(event:MouseEvent):void
		{
			TweenMax.to(_thumb._bk, .5, {glowFilter:{color:0x8989F5, alpha:0, blurX:0, blurY:0}});	
		}
		
		private function over_handler(event:MouseEvent):void
		{
			TweenMax.to(_thumb._bk, .5, {glowFilter:{color:0x8989F5, alpha:1, blurX:20, blurY:20}});	
		}
	}
}

