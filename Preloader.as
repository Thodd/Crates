package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.display.Sprite;
	import flash.text.TextField;
	import punk.core.*;
	
	[SWF(width = "416", height = "288")]
	
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Preloader extends MovieClip 
	{
		[Embed(source = 'net/jmp0/crates/res/silentbg.png')] static private var imgLoading:Class;
		private var loading:Bitmap = new  imgLoading;
		
		private var square:Sprite = new Sprite();
		private var border:Sprite = new Sprite();
		private var text:TextField = new TextField();
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			
			// show loader
			addChild(text);
			text.x = stage.width / 2 - 30;
			text.y = stage.stageHeight / 2 - 30;
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			square.graphics.beginFill(0xF2F2F2);
			square.graphics.drawRect(0,0,(loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 154, 20);
			square.graphics.endFill();
			
			border.graphics.lineStyle(2,0xFFFFFF);
			border.graphics.drawRect(0, 0, 208, 28);
			
			text.textColor = 0x000000;
			text.text = "Loading: " + Math.ceil((loaderInfo.bytesLoaded/loaderInfo.bytesTotal)*100) + "%";
			
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
			
		}
		
		private function startup():void 
		{
			// hide loader
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}