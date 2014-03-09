package net.jmp0.crates 
{
	import net.jmp0.crates.effects.Cursor;
	import net.jmp0.crates.effects.Curtain;
	import net.jmp0.crates.effects.GrungeEffect;
	import punk.Backdrop;
	import punk.core.Spritemap;
	import punk.core.World;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class Titlescreen extends World
	{
		//the actual titlescreen
		[Embed(source = 'res/title/titlescreen.png')] private var imgTitlescreen:Class;
		private var bgTitlescreen:Backdrop = new Backdrop(imgTitlescreen, 0, 0, true, true);


		//effects
		private var grungeEffect:GrungeEffect = new GrungeEffect();
		public var curtainEffect:Curtain = new Curtain(true, 3, false, curtainFinished);
		
		
		
		public function Titlescreen() { }
		
		
		override public function init():void {
			
			this.add(bgTitlescreen);
			this.add(grungeEffect);
			this.add(curtainEffect);
			this.add(new Cursor(this));
			
			//rising the curtain for the first time
			curtainEffect.start(curtainFinished); //(curtainFinished
			
			MusicPlayer.turnUp();
			MusicPlayer.start();
		}
		
		
		public function curtainFinished():void {
			trace("curtain stopped");
		}
	}

}