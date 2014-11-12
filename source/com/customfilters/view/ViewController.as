
/* Loaded by RenderFilter.as which passes it a reference to the initial stage which triggers 
***	the creation of the StageView instance.
*/

package com.customfilters.view{
		import flash.display.*;
		import com.ddiggs.transitions.view.StageView
		
		
		public class ViewController extends Sprite{
			
			private var _StageView: StageView;
			
			private var _myStage: DisplayObject; //holds a reference to the initial stage
		
			public function ViewController(){
				
				trace("ViewController() v1")
					
			}
			
			public function initStage(myStage:DisplayObject){
				
				_myStage = myStage;
				trace("VC myStage: " + _myStage);
				_StageView = new StageView();
				
				_StageView.initStage(_myStage, 800, 600);// pass the initial stage reference to _StageView and the length and width that the project will be constrained to
				
				addChild(_StageView);
			
			}		
		}
}