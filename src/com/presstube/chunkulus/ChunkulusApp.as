package com.presstube.chunkulus {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.Keyboard;
	
	public class ChunkulusApp extends Sprite {
		
		private var scaleStage:ScaleStage;
		private var bgCircle:Sprite;
		private var activeStage:ActiveStage;
		private var parallaxScroller:ParallaxScroller;
		private var flyingChunk:Chunkulus;
		private var boundingCircle:Sprite;
		private var radius:int;
		private var spawning:Boolean;
		
		public function ChunkulusApp() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			loadAssets();
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				down();
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
				up();
			});
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (e.keyCode == Keyboard.SPACE) {
					down();
				}
			});
			stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void {
				if (e.keyCode == Keyboard.SPACE) {
					up();
				}
			});
			
			function down():void {
				spawning = true;
				flyingChunk.bodyAnimIndex = 2;
				scaleStage.scale = 1.1;
			}
			
			function up():void {
				flyingChunk.bodyAnimIndex = 1;
				spawning = false;
				scaleStage.scale = 1;
			}
		}
		
		private function loadAssets():void {
			var bgImagesLoader:Loader = new Loader;
			bgImagesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				init();
			});
			bgImagesLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
				trace("ERROR LOADING ASSETS: " + e);
			});
//			bgImagesLoader.load(new URLRequest("http://presstube.com/chunkulus/assets.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
			bgImagesLoader.load(new URLRequest("assets.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function init():void {
			radius = 500;
			
			buttonMode = true;
			useHandCursor = true;
			
			addChild(scaleStage = new ScaleStage);
			scaleStage.addChild(bgCircle = makeBoundingCircle());
			scaleStage.addChild(activeStage = new ActiveStage);
			scaleStage.addChildAt(parallaxScroller = new ParallaxScroller(scaleStage, activeStage, radius), 1);
			activeStage.addChild(flyingChunk = new Chunkulus(activeStage, radius));
			
			scaleStage.addChildAt(boundingCircle = makeBoundingCircle(), 0);
			scaleStage.mask = boundingCircle;
			
			activeStage.trackingTarget = flyingChunk;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function makeBoundingCircle():Sprite {
			var boundingCircle:Sprite = new Sprite;
			boundingCircle.graphics.beginFill(0x999999);
			boundingCircle.graphics.drawCircle(0, 0, radius);
			return boundingCircle;
		}
		
		private function onEnterFrame(e:Event):void {
			if (spawning) {
				flyingChunk.open();
				flyingChunk.spawnChunklet();
				flyingChunk.spawnChunklet();
				flyingChunk.spawnChunklet();
				
			} else {
				
				flyingChunk.close();
			}
		}
	}
}
