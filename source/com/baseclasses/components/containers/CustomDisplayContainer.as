package com.baseclasses.components.containers
{

	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import com.baseclasses.geometricshapes.Rect;

	public class CustomDisplayContainer extends Sprite
	{
		private var _size:Number;
		private var _id:int;
		private var _borderColor:Number;
		private var _bkColor:Number;
		private var _bk:Rect = new Rect();
		private var _mask:Rect = new Rect();
		private var _width:Number;
		private var _height:Number;
		private var _bWidth:Number;
        private var _itemHeight:Number;
		private var _itemY:Number;
		private var _contentHeight:Number=0;
		private var _spacing:Number=25;

        public function CustomDisplayContainer()
        {
        	super();
        }

		public function makeContainer(wid:Number, high:Number, bkcol:Number, brdcol:Number, bwidth:Number):void
		{
			_width = wid;
			_height = high;
			_bkColor = bkcol;
			_borderColor = brdcol;
			_bWidth = bwidth;
			//_spacing = spacing;
			
			_bk.makeRect(_width, _height, _bkColor, _borderColor, _bWidth);
			
			//_bk.setRect(_width, _height, 0xC00C55,0xCFFC55,5);
			addChild(_bk);
			//setRect(wid:number, high:Number, bkColor:Number, borderColor:Number, borderWidth:Number)
		}
		
		public function setContainer(wid:Number, high:Number):void
		{
			_width = wid;
			_height = high;
			_bk.setRect(_width, _height);
			trace("height of item: " + _itemHeight + " item y: " + _itemY);
			
		}
		
		public function addContent(item:Sprite, topPadding:Number):void
		{
			//item.x= (_width - item.width) / 2;
			
			addChild(item);
			item.y = _contentHeight + topPadding;
			
			_contentHeight = item.height + item.y;
			
			trace("CONTENT ADDED AN IS: " + item);
			trace("item.width: " + item.width + " container width: " + _width);
			trace("item.height: " + item.height + " _contentHeight: " + _contentHeight);
		}
	
	
	}

}

