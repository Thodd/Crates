package net.jmp0.crates.effects 
{
	import punk.Acrobat;
	import punk.core.Spritemap;
	import punk.core.World;
	import punk.util.*;
	import net.jmp0.crates.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class Cursor extends Acrobat
	{
	
		//The Cursor
		[Embed(source = '../res/env/crate.png')] private var imgCrate:Class;
		private var sprCrate:Spritemap = FP.getSprite(imgCrate, 16, 16, true, false, 0, 0, true);
		
		private var cursor:int = 0;
		
		private var titlescreen:Titlescreen;
		
		public function Cursor(titlescreen:Titlescreen) {
			this.titlescreen = titlescreen;
		}
		
			
		override public function update():void {
			
			if (Input.pressedKey(Key.DOWN)) {
				cursor += 1;
				cursor %= 4;
			}else if (Input.pressedKey(Key.UP)) {
				cursor -= 1;
				if (cursor < 0) {
					cursor = 3;
				}
			}
			
			//only process keypress event after the titlescreen has lift its curtain
			if (Input.pressedKey(Key.ENTER) && titlescreen.curtainEffect.stopped) {
				switch(cursor) {
					case 0: titlescreen.curtainEffect.start(curtainDownStart); break;
					case 1: titlescreen.curtainEffect.start(curtainDownPassword); break;
					case 2: titlescreen.curtainEffect.start(curtainDownHelp); break;
					case 3: titlescreen.curtainEffect.start(curtainDownCredits); break;
				}
			}
			
		}
		
		
		private function curtainDownStart():void {
			var lt:LevelTracker = LevelTracker.getInstance();
			lt.switchToLevelMsg(lt.next(), true);
		}
		private function curtainDownPassword():void {
			FP.goto = new PasswordScreen();
		}
		private function curtainDownHelp():void {
			FP.goto = new HelpScreen();
		}
		private function curtainDownCredits():void {
			FP.goto = new CreditScreen();
		}
		
		
		override public function render():void {
			switch(cursor) {
				case 0: drawSprite(sprCrate, 0, 67, 71, false, false); break;
				case 1: drawSprite(sprCrate, 0, 52, 87, false, false); break;
				case 2: drawSprite(sprCrate, 0, 66, 103, false, false); break;
				case 3: drawSprite(sprCrate, 0, 53, 119, false, false); break;
			}
		}
		
	}

}