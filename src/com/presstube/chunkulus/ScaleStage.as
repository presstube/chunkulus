package com.presstube.chunkulus {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ScaleStage extends Sprite {
		
		private var _scale:Number;
		
		public function ScaleStage() {
		}
		
		public function set scale(scale:Number):void {
			scaleX = scaleY = scale;
			_scale = scale;
		}
		
		public function get scale():Number {
			return _scale;
		}
	}
}
