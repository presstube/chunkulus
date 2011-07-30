package com.presstube.chunkulus {
	import com.presstube.utils.PTmove;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ScaleStage extends Sprite {
		
		private var _scale:Number;
		private var mover:PTmove;
		
		public function ScaleStage() {
			mover = new PTmove(this);
			scale = 1;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function set scale(scale:Number):void {
			_scale = scale;
		}
		
		private function onEnterFrame(event:Event):void {
			mover.springScaleTo(_scale, 0.1, .6);
//			mover.scaleTo(_scale, 10);
		}
		
		public function get scale():Number {
			return _scale;
		}
	}
}
