package com.sellproto.version1.view.components
{
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import com.sellproto.version1.view.*;
	import com.sellproto.version1.events.*;

	public class CheckBoxRow extends Sprite
	{
		private var _width:Number;
		private var _id:String;
		private var _label:String;
		private var _checkBox_arr:Array = new Array();
		private var _selected_arr:Array = new Array();
		private var _checkBoxCnt = 0;
		private var _type:String;
		private var _minSelected:int;
		private var _deactivatedBox:Number = -1;
        
        public function CheckBoxRow()
        {
			trace("CheckBoxRow()");
        	super();
        }

		public function setCheckBoxRow(id:String, label:String, width:Number, minSelected:int, my_type:String):void
		{
			_id = id;
			_width = width;
			_label = label;
			_type = my_type;
			_minSelected = minSelected;
		}
		
		public function addCheckBox(boxLabel:String, isSelected:Boolean):void
		{
			_checkBoxCnt ++;
			var checkBox:TriangleCheckBox = new TriangleCheckBox();
			checkBox.setTriCheckBox(_checkBoxCnt, _id, boxLabel);
			checkBox.addEventListener(CheckBoxEvent.TOGGLE, doCheckBoxHit);
			
			if(isSelected)
			{
				checkBox.setActive(true);
				_selected_arr.push(true);
			}
			else
			{
				checkBox.setActive(false);
				_selected_arr.push(false);
			}
			addChild(checkBox);
			_checkBox_arr.push(checkBox);
			distributeBoxes();
		}
		
		public function unCheckUnselected(selected:int):void
		{
			for (var t:int = 0; t<_checkBox_arr.length; t++) 
			{
				if(selected != t)
				{
					_checkBox_arr[t].setActive(false);
					_selected_arr[t] = false;
				}
			}
			dispatchEvent(new CheckBoxRowEvent(CheckBoxRowEvent.ROWDATA, _id, _selected_arr));
		}
		
		private function distributeBoxes():void
		{
			for (var i:int = 0; i<_checkBox_arr.length; i++) 
			{
				_checkBox_arr[i].x = (_width / _checkBoxCnt) * i;
			}
		}
		
		private function deactivateBox(which:int):void
		{
			_checkBox_arr[which].boxDeactivate();
			_selected_arr[which] = true;
			dispatchEvent(new CheckBoxRowEvent(CheckBoxRowEvent.ROWDATA, _id, _selected_arr));
			_deactivatedBox = which;
			
		}
		
		private function activateBox(which:int):void
		{
			_checkBox_arr[which].boxActivate();
		}
		
		private function doCheckBoxHit(e:CheckBoxEvent):void
		{
			if(_selected_arr[e.whichButton]) //is already selected
			{
				trace("already selected -- _minSelected: " + _minSelected );
				if(_minSelected > 0) //is a required number of checked fields
				{
					//count number of 'true' checkboxes
					var t_cnt:int=0;
					for (var i:int = 0; i<_selected_arr.length; i++) 
					{
						if(_selected_arr[i] == true)
						{
							t_cnt++;
						}
					}
					trace("t_cnt: " + t_cnt);
					if(t_cnt < _minSelected+1)
					{
						//do nothing;
					}
					else
					{
						_selected_arr[e.whichButton] = false;
						_checkBox_arr[e.whichButton].setActive(false);
					}	
				}
				else
				{
					_selected_arr[e.whichButton] = false;
					_checkBox_arr[e.whichButton].setActive(false);
				}
			}
			else //not already selected
			{
				_selected_arr[e.whichButton] = true;
				_checkBox_arr[e.whichButton].setActive(true);
			}
			
			
			switch(_type)
			{
				case "inclusive":
					dispatchEvent(new CheckBoxRowEvent(CheckBoxRowEvent.ROWDATA, _id, _selected_arr));
				break;
				
				case "exclusive":
					unCheckUnselected(e.whichButton);
				break;
			}
		}
	}
}

