package com.ddiggs.transitions.baseclasses{
	
	import flash.display.*
	import flash.events.*
		
	public class BasicStage extends Sprite{
		
		private var _docStage:DisplayObject; //holder for the initial document stage
		private var _docStageWidth:int; //width of the document stage
		private var _docStageHeight:int; //height of the document stage
		private var _myStageWidth:int; //width of display stage
		private var _myStageHeight:int; //height of display stage
		private var _stageBorder:Sprite;  //hold out line of the stage
		
		public function BasicStage():void{
			
			super();
		}
		
		public function initStage(docStage:DisplayObject, myStageWidth:int, myStageHeight:int):void{
		
			_docStage = docStage; 
			_docStageWidth = _docStage.stage.stageWidth; 
			_docStageHeight = _docStage.stage.stageHeight;
			_myStageWidth = myStageWidth; 
			_myStageHeight = myStageHeight; 
			_docStage.stage.scaleMode = StageScaleMode.NO_SCALE; //don't allow document stage to scale
            _docStage.stage.align = StageAlign.TOP_LEFT; //allign document in top left corner of swf in html page
            _docStage.stage.addEventListener(Event.RESIZE, resizeHandler); //dispatch event when stage is resized
			_stageBorder = new Sprite();
			_stageBorder = outlineMyStage(_myStageWidth, _myStageHeight); //outline the display stage
			
			addChild(_stageBorder);
			
			trace("BasciStage _docStageWidth " + _docStageWidth);
			trace("BasciStage _docStageHeight " + _docStageHeight);
		
		}
		
		/*
		** center a display object to the display stage
		*/
			
		protected function centerItem(item:DisplayObject):void{
			
			trace("STAGE item.width: " +item.width);
			item.x = (_myStageWidth - item.width) / 2;
		}
		
		/*
		*** outline the stage with a one pixel white border
		*/
			
		private function outlineMyStage(wid:int, high:int):Sprite{
			
			var rect:Sprite = new Sprite();
			rect.graphics.lineStyle(1, 0xffffff);
			rect.graphics.moveTo(0,0);
			rect.graphics.lineTo(0, high-1);
			rect.graphics.lineTo(wid-1, high-1);
			rect.graphics.lineTo(wid-1, 0);
			rect.graphics.lineTo(0,0);
			return rect;
		}
		
		/*
		*** handles stage resizing so that display stage remains centered
		*/
			
	    private function resizeHandler(event:Event):void{
		
			_docStageWidth = _docStage.stage.stageWidth;
			_docStageHeight = _docStage.stage.stageHeight;
			trace("BasciStage _docStageWidth " + _docStageWidth);
			trace("BasciStage _docStageHeight " + _docStageHeight);
			this.x = (_docStageWidth - _myStageWidth) / 2;
		}
		
		public function get docStageWidth():int{
		
			return _docStageWidth;
		}
		
		public function get docStageHeight():int{
		
			return _docStageHeight;
		}
	}
}