package net.jmp0.crates.effects 
{
	import net.jmp0.crates.Titlescreen;
	import punk.Actor;
	import punk.core.Spritemap;
	import punk.Textplus;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class BackToTitleLabel extends Actor
	{
		
		//The SilentBG
		[Embed(source = '../res/backtotitleScreen.png')] private var imgBg:Class;
		private var sprBg:Spritemap = FP.getSprite(imgBg, 0, 0, false, false, 0, 0, true);

		private var backToTitleCallback:Function;
		
		public function BackToTitleLabel(backToTitleCallback:Function) 
		{
			this.backToTitleCallback = backToTitleCallback;
			active = false;
			visible = false;
			this.sprite = sprBg;
			this.depth = -999;
		}
		
		public function show():void {
			active = true;
			visible = true;
			x = FP.camera.x;
			y = FP.camera.y;
		}
		
		public function hide():void {
			backToTitleCallback();
			active = false;
			visible = false;
		}
		
		
		override public function update():void {
			if (Input.pressedKey(Key.Y)) {
				FP.goto = new Titlescreen();
			}else if (Input.pressedKey(Key.N)) {
				hide();
			}
		}		
		
	}

}