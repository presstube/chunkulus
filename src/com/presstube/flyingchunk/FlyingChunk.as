package com.presstube.flyingchunk {
	import com.greensock.plugins.VolumePlugin;
	import com.presstube.utils.PTmove;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	import flashx.textLayout.elements.SpanElement;
	
	public class FlyingChunk extends Sprite {
		
		private static const OPEN:String = "OPEN";
		private static const CLOSE:String = "CLOSE";
		
		private var activeStage:ActiveStage;
		private var radius:Number;
		
		private var _velocity:Point = new Point;;
		private var drag:Number = .98;
		private var directionInDegrees:Number;
		
		private var upKeyPressed:Boolean;
		private var leftKeyPressed:Boolean;
		private var rightKeyPressed:Boolean;
		
		private var body:AssetBody;
		private var bodySpawnPoints:Array;
		private var _bodyAnimIndex:int;
		
		private var exhaustPoint:MovieClip;
		
		private var head:MovieClip;
		private var direction:String;
		
		public function FlyingChunk(activeStage:ActiveStage, radius:Number) {
//			makeTestGraphics();
			this.activeStage = activeStage;
			this.radius = radius;
			bodyAnimIndex = 2;
			makeBody();
			makeHead();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function makeBody():void {
			body = new AssetBody;
			exhaustPoint = body.exhaustPoint;
			exhaustPoint.visible = false;
			bodySpawnPoints = [];
			for (var i:int = 0; i < body.numChildren; i++) {
				var child:DisplayObject = body.getChildAt(i);
				if (child.name == "spawnPoint") {
					bodySpawnPoints.push(child);
					child.visible = false;
				}
			}
			addChild(body);
		}
		
		private function makeHead():void {
			head = new AssetHead;
			head.gotoAndStop(1);
			addChild(head);
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			rotation = 45;
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.UP) {
				upKeyPressed = true;
			} else if (e.keyCode == Keyboard.LEFT) {
				leftKeyPressed = true;
			} else if (e.keyCode == Keyboard.RIGHT) {
				rightKeyPressed = true;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.UP) {
				upKeyPressed = false;
			} else if (e.keyCode == Keyboard.LEFT) {
				leftKeyPressed = false;
			} else if (e.keyCode == Keyboard.RIGHT) {
				rightKeyPressed = false;
			}
		}
		
		public function onEnterFrame(e:Event):void {
			applyForces();
			spawnBodyAnims();
			spawnExhaust();
			animateHead();
		}
		
		private function applyForces():void {
			var thrust:Number;
			var torque:Number;
			
			if (leftKeyPressed && !rightKeyPressed) {
				torque = -10;
			} else if (rightKeyPressed && !leftKeyPressed) {
				torque = 10;
			} else {
				torque = 0;
			}
			rotation += torque;
			thrust = .8;
			var thrustToAdd:Point = Point.polar(thrust, PTmove.degreesToRadsAdjusted(rotation));
			_velocity.x = (_velocity.x + thrustToAdd.x) * drag;
			_velocity.y = (_velocity.y + thrustToAdd.y) * drag;
			
			x += _velocity.x;
			y += _velocity.y;
		}
		
		private function spawnBodyAnims():void {
			for (var i:int = 0; i < bodySpawnPoints.length; i++) {
				if (Math.random() < .2) {
					var spawnPoint:MovieClip = bodySpawnPoints[i] as MovieClip;
					var ran:int = Math.floor(Math.random() * 1) + 3;
					var bodyAnim:MovieClip = new (getDefinitionByName("BodyAnim_" + _bodyAnimIndex) as Class);
					var spread:int = 10;
					bodyAnim.x = spawnPoint.x + (Math.floor(Math.random() * spread) - Math.floor(Math.random() * spread));
					bodyAnim.y = spawnPoint.y + (Math.floor(Math.random() * spread) - Math.floor(Math.random() * spread));
					if (Math.random() < .5) {
						bodyAnim.scaleX = -1;
					}
					bodyAnim.rotation = spawnPoint.rotation + (Math.floor(Math.random() * spread) - Math.floor(Math.random() * spread));
					bodyAnim.addEventListener(Event.ENTER_FRAME, onBodyAnimEnterFrame);
					addChildAt(bodyAnim, 0);
				}
			}
		}
		
		private function makeTestGraphics():void {
			graphics.beginFill(0x000000);
			graphics.drawRect(-10, -10, 20, 20);
			graphics.endFill();
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(0, -10, 5);
		}
		
		public function get velocity():Point {
			return new Point(_velocity.x, _velocity.y);
		}
		
		private function onBodyAnimEnterFrame(e:Event):void {
			var bodyAnim:MovieClip = e.target as MovieClip;
			if (bodyAnim.currentFrame == bodyAnim.totalFrames) {
				bodyAnim.removeEventListener(Event.ENTER_FRAME, onBodyAnimEnterFrame);
				bodyAnim.parent.removeChild(bodyAnim);
			}
		}
		
		private function spawnExhaust():void {
			var exhaust:MovieClip = new AssetExhaust;
			var spawnPoint:Point = new Point(exhaustPoint.x, exhaustPoint.y);
			spawnPoint = localToGlobal(spawnPoint);
			spawnPoint = activeStage.globalToLocal(spawnPoint);
			exhaust.x = spawnPoint.x + ((Math.random() * 5) - (Math.random() * 5));
			exhaust.y = spawnPoint.y + ((Math.random() * 5) - (Math.random() * 5));
			exhaust.rotation = rotation;
			if (Math.random() < .5) {
				exhaust.scaleX = -1;
			}
			exhaust.gotoAndStop(Math.floor(Math.random() * exhaust.totalFrames));
			activeStage.addChild(exhaust);
			exhaust.addEventListener(Event.ENTER_FRAME, onExhaustEnterFrame);
		}
		
		private function onExhaustEnterFrame(e:Event):void {
			var exhaust:MovieClip = e.target as MovieClip;
			if (Math.random() < .1) {
				exhaust.removeEventListener(Event.ENTER_FRAME, onExhaustEnterFrame);
				exhaust.parent.removeChild(exhaust);
			}
		}
		
		public function open():void {
			direction = OPEN;
		}
		
		public function close():void {
			direction = CLOSE;
			head.rotation = 0;
		}
		
		private function animateHead():void {
			if (direction == OPEN) {
				head.gotoAndStop(3);
			} else {
				head.gotoAndStop(head.currentFrame - 1);
			}
		}
		
		public function spawnChunklet():void {
			var spread:Number = 10;
			var spitRotation:Number = rotation + (Math.random() * spread - Math.random() * spread);
			var chunklet:Chunklet = new Chunklet(activeStage, radius, (Math.random() * 10) + 50, spitRotation, velocity);
			chunklet.x = x;
			chunklet.y = y;
			if (Math.random() < .5) {
				activeStage.addChild(chunklet);
				
			} else {
				activeStage.addChildAt(chunklet, 0);
				
			}
			head.rotation = spitRotation - rotation;
		}
		
		public function advanceBodyAnim():void {
			_bodyAnimIndex = (_bodyAnimIndex == 5) ? 1 : _bodyAnimIndex + 1;
		}
		
		public function set bodyAnimIndex(index:int):void {
			_bodyAnimIndex = index;
		}
	
	}
}
