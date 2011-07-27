package com.presstube.flyingchunk {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ActiveStage extends Sprite {
		
		public static const MOVED:String = "MOVED";
		
		private var _trackingTarget:DisplayObject;
		private var _amountToMove:Point;
		
		public function ActiveStage() {
		
		}
		
		public function set trackingTarget(trackingTarget:DisplayObject):void {
			_trackingTarget = trackingTarget;
			if (_trackingTarget) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			} else {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public function onEnterFrame(e:Event):void {
			_amountToMove = new Point((-_trackingTarget.x - x) / 2, (-_trackingTarget.y - y) / 2)
			x += _amountToMove.x;
			y += _amountToMove.y;
			dispatchEvent(new Event(MOVED));
		}
		
		public function get amountToMove():Point {
			return _amountToMove;
		}
	}
}
