package net.jmp0.crates.effects 
{
	import net.jmp0.crates.Titlescreen;
	import punk.Acrobat;
	import punk.core.Spritemap;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class FinSplash extends Acrobat
	{
				
		[Embed(source = '../res/finSplash.png')] private var imgFinSplash:Class;
		private var sprFinSplash:Spritemap = FP.getSprite(imgFinSplash, 0, 0, false, false, 20, 20, true);
		
		private var started:Boolean = false;
		
		public function FinSplash(){
			this.sprite = sprFinSplash;
			x = 70;
			y = 70;
			alpha = 0;
			this.depth = -1001;
		}
		
		public function start():void {
			started = true;
		}
		
		
		override public function update():void {
			if (started) {
				alpha += 0.05;
			}
			
			if (alpha >= 1 && Input.pressedKey(Key.ESCAPE)) {
				FP.goto = new Titlescreen();
			}
		}
	}

}