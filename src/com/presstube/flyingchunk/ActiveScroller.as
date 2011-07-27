package com.presstube.flyingchunk {
	import com.gskinner.PixelPerfectCollisionDetection;
	import com.presstube.utils.PTmove;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	public class ActiveScroller extends Sprite {
		
		private var activeStage:ActiveStage;
		private var items:Array;
		private var radius:Number;
		
		public function ActiveScroller(activeStage:ActiveStage, radius:Number) {
			this.activeStage = activeStage;
			this.radius = radius;
			
			items = [];
			
			addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
				makeItems(20);
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			});
		}
		
		private function makeItems(numItems:int):void {
			for (var i:int = 0; i < numItems; i++) {
				var item:DisplayObject = makeTinyBGChunkle();
				item.x = ((Math.random() * radius) * 2) - ((Math.random() * radius) * 2);
				item.y = ((Math.random() * radius) * 2) - ((Math.random() * radius) * 2);
				item.rotation = Math.random() * 360;
//				item.scaleX = item.scaleY = 5;
//				item.cacheAsBitmap = true;
				addChild(item);
				items.push(item);
			}
		}
		
		private function makeItem():Sprite {
			var item:Sprite = new Sprite;
			item.graphics.lineStyle(1);
			item.graphics.drawCircle(-2, -2, 4);
			return item;
		}
		
		private function makeNothingItem():Sprite {
			var item:Sprite = new Sprite;
			var ran:int = Math.floor(Math.random() * 2) + 1;
			var nothingClass:Class = getDefinitionByName("BG_" + 2) as Class;
			var nothing:Sprite = new nothingClass() as Sprite;
			return nothing
		}
		
		private function makeTinyBGChunkle():MovieClip {
			var itemClass:Class = getDefinitionByName("AssetBG") as Class;
			var item:MovieClip = new itemClass() as MovieClip;
			item.gotoAndStop(Math.floor(Math.random() * item.totalFrames) + 1);
			return item;
		}
		
		private function onEnterFrame(e:Event):void {
			checkForWrap();
		}
		
		private function checkForWrap():void {
			for (var i:int = 0; i < items.length; i++) {
				var item:MovieClip = items[i];
				var itemPosition:Point = new Point(item.x, item.y);
				var centerPosition:Point = new Point(-activeStage.x, -activeStage.y);
				var dist:Number = Point.distance(centerPosition, itemPosition);
				var distAllowed:Number = radius + item.width + item.height;
				if (dist > (distAllowed)) {
					var direction:Number = PTmove.degreesFromPointToPoint(centerPosition, itemPosition);
					item.gotoAndStop(Math.floor(Math.random() * item.totalFrames) + 1);
					var respawnPoint:Point = Point.polar(distAllowed, PTmove.degreesToRads(getOppositeSemiCircleDirection(direction)));
					item.x = respawnPoint.x + centerPosition.x;
					item.y = respawnPoint.y + centerPosition.y;
					item.rotation = Math.random() * 360;
					var ct:ColorTransform = new ColorTransform;
					ct.color = 0x000000;
					item.transform.colorTransform = ct;
				}
			}
		}
		
		private function getOppositeSemiCircleDirection(direction:Number):Number {
			return Math.random() * 180 + (direction + 90);
		}
		
		public function hitTest(objectToTest:DisplayObject):Boolean {
			var isColliding:Boolean;
			for (var i:int = 0; i < items.length; i++) {
				var item:MovieClip = items[i];
				if (PixelPerfectCollisionDetection.isColliding(item, objectToTest, activeStage, true)) {
					isColliding = true;
//					var ct:ColorTransform = new ColorTransform;
//					ct.color = 0xff0000;
//					item.transform.colorTransform = ct;
//					item.scaleX = item.scaleY = 2;
					break;
				} else {
//					var ct:ColorTransform = new ColorTransform;
//					ct.color = 0x000000;
//					item.transform.colorTransform = ct;
//					item.scaleX = item.scaleY = 1;
				}
				
			}
			return isColliding;
		}
	}
}
