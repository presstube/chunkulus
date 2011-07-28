package com.presstube.chunkulus {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ScaleStage extends Sprite {
		
		private var _scale:Number;
		
		public function ScaleStage() {
			scale = 1;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function set scale(scale:Number):void {
			_scale = scale;
		}
		
		private function onEnterFrame(event:Event):void {
			var scaleDist:Number = (_scale - scaleX) / 10;
			scaleX += scaleDist;
			scaleY += scaleDist;
		}
		
		public function get scale():Number {
			return _scale;
		}
	}
}
