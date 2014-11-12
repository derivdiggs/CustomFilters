/*
//		Rect.as
//		Creates a rectangle with an opptional border. 
//
//
//
*/

package com.baseclasses.geometricshapes
{
	import flash.display.*;
	import com.baseclasses.geometricshapes.BaseRect;
	
	public class Rect extends BaseRect
	{
		private var _height:Number;
		private var _width:Number;
		private var _borderColor:Number;
		private var _bkColor:Number;
		private var _borderWidth:Number;
		private var _bk:Sprite = new Sprite();
		private var _border:Sprite = new Sprite();
		
		
		public function Rect():void
		{
			super();
		}
		
		public function makeRect(wid:Number, high:Number, bkColor:Number, borderColor:Number, borderWidth:Number):void
		{
			_width = wid;
			trace("WIDTH1 : " + _width);
			_height = high;
			_bkColor = bkColor;
			_borderColor = borderColor;
			_borderWidth = borderWidth;
			initBackground();
		}
		
		public function setRect(wid:Number, high:Number):void
		{
			_width = wid;
			trace("WIDTH1 : " + _width);
			_height = high;
			
			if(_borderColor != 0)
			{
				//_border = setBaseRect(_width, _height);
				//_bk = setBaseRect(_width - _borderWidth, _height - _borderWidth);
				
				_border.width = _width;
				_border.height = _height;
				_bk.width = _width - _borderWidth;
				_bk.height = _height - _borderWidth;
				
				
				_bk.x = _borderWidth/2;
				_bk.y = _borderWidth/2;
				
			}
			else
			{
				_border = null;
				//_bk = setBaseRect(_width, _height);
				_bk.width = _width;
				_bk.height = _height;
			}
		}
		
		private function initBackground():void
		{
			if(_borderColor != 0)
			{
				_border = makeBaseRect(_width, _height, _borderColor, 1);
				_bk = makeBaseRect(_width - _borderWidth, _height - _borderWidth, _bkColor, 1);
				_bk.x = _borderWidth/2;
				_bk.y = _borderWidth/2;
				addChild(_border);
				addChild(_bk);
			}
			else
			{
				_border = null;
				_bk = makeBaseRect(_width, _height, _borderColor, 1);
				addChild(_bk);
			}
			
		}
	}
}