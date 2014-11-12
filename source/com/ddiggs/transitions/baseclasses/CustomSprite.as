package com.ddiggs.transitions.baseclasses
{

import flash.display.*;
import flash.utils.*;
import flash.events.*;

	public class CustomSprite extends Sprite
	{
		
		protected var _allKids_arr:Array = new Array();
		protected var _timer:Timer;
		private var _interval:Number;
		private var _onTimerDone:Function;
		private var _onTimerInterval:Function;
		private var isTimerPaused:Boolean=false;
		private var currentTime:int=0;
		private var _timerArray:Array = new Array();
		private var _isTimer:Boolean = false;
        
        public function CustomSprite()
        {
        	super();
        }

		public function addKid(son:Object):void
		{
			_allKids_arr.push(son);
			if(son is Bitmap)
			{
				//trace("bitmap>")
			}
			else
			{
				//trace("***CUSTOMSPRITE  new son: " + son+ "son has this many kids: "+ son.numChildren);
				//trace("***CUSTOMSPRITE numChildren: "+son.getChildAt(0))
			}
		}
		
		public function killKids():void
		{
			for(var a:uint=0;a<_allKids_arr.length;a++)	
			{
				if(_allKids_arr[a] != null)
				{
					//trace("***CUSTOMSPRITE  dead son: " + _allKids_arr[a]);
					removeChild(_allKids_arr[a]);
					_allKids_arr[a] = null;
				}
			}
		}
		
		public function die():void
		{
			for(var a:uint=0;a<_allKids_arr.length;a++)	
			{
				if(_allKids_arr[a] != null)
				{
					//trace("***CUSTOMSPRITE  dead son: " + _allKids_arr[a]);
					removeChild(_allKids_arr[a]);
					_allKids_arr[a] = null;
				}
			}
			setTimeout(suicide, 1);
		}
		
		public function listKids():Array
		{
			return _allKids_arr;
		}
		
		private function suicide():void
		{
			parent.removeChild(this);
		}
		
		protected function getRandom(lowest:int, range:int):int{
			
			return Math.floor(Math.random() * range) + lowest;
		
		}
			
		
		
		protected function initTimer(time:int, interval:uint, autoStart:Boolean, myFunction:Function, myOtherFunction):void
		{
			//time is the amount of time an interval is in 1/1000sec and time for my function
			//interval is the amount of time units until myOtherFunction
			_isTimer = true;
			_timer = new Timer(time, 0);
			_timerArray.push(_timer);
			_onTimerDone=myFunction;
			_onTimerInterval=myOtherFunction;
			_interval=interval;
			_timer.addEventListener(TimerEvent.TIMER, checkTime);
			if(autoStart)
			{
				startTimer();
			}
		}
		
		protected function killTimer():void
		{
			stopTimer();
			trace("killtime()");
			if(_isTimer)
			{
				for(var t:int=0; t < _timerArray.length; t++)
				{
					_timerArray[t] = null;

				}
				_timer = null;
				currentTime = 0;
				_isTimer = false;
			}
			
		}
		
		protected function checkTime(evtObj:Event):void
		{
			if(!isTimerPaused)
			{
				var tmpF:Function = _onTimerInterval;
				tmpF();
				
				currentTime++;
				if(currentTime==_interval)
				{
					var tmp:Function = _onTimerDone;
					tmp();
					stopTimer();
					killTimer();
				}
			}
		}
		
		protected function startTimer():void{
			_timer.start();
			isTimerPaused=false;
		}
		
		protected function stopTimer():void{
			_timer.stop();
			isTimerPaused=true;
		}
        
	}

}

