package net.jmp0.crates.effects
{
	import punk.Acrobat;
	import punk.core.Spritemap;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class Curtain extends Acrobat
	{
		
		//grunge effect
		[Embed(source = '../res/title/curtain.png')] private var imgCurtain:Class;
		private var sprCurtain:Spritemap = FP.getSprite(imgCurtain, 0, 0, false, false, 0, 0, true);
		
		
		public var down:Boolean = false;
		
		public var speed:int = 2;
		
		public var repeat:Boolean = true;
		
		public var callback:Function;
		
		public var stopped:Boolean = true;
		
		public var startx:int = 0;
		public var starty:int = 0;

		public function Curtain(down:Boolean = false, speed:int = 2, repeat:Boolean = true, callback:Function = null, startx:int = 0, starty:int = 0) {
			this.down = down;
			
			this.startx = startx;
			this.starty = starty;
			
			if (!down) {
				y = starty - sprCurtain.height;
			}else {
				y = starty;
			}
			x = startx;
			
			this.speed = speed;
			this.repeat = repeat;
			this.callback = callback;
			
			this.delay = 7;
			this.depth = -1000;
			this.sprite = sprCurtain;
		}
		
		
		override public function update():void {
			if (!down && !stopped) {
				y += speed;
			}
			
			if (y >= starty && !down) { //+ speed
				if (callback != null) {
					callback();
				}
				if (!repeat) {
					stopped = true;
				}
				down = true;
			}
			
			if (down && !stopped) {
				y -= speed;
			}
			
			if (y <= starty - sprCurtain.height && down) { //-1 * 
				if (callback != null) {
					callback();
				}
				if (!repeat) {
					stopped = true;
				}
				down = false;
			}
		}
		
		
		public function start(callback:Function):void {
			this.callback = callback;
			stopped = false;
		}
		
		public function stop():void {
			this.callback = callback;
			stopped = true;
		}
		
	}

}
