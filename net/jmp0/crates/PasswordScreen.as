package net.jmp0.crates 
{
	import net.jmp0.crates.effects.Curtain;
	import net.jmp0.crates.effects.GrungeEffect;
	import punk.Actor;
	import punk.Backdrop;
	import punk.core.Spritemap;
	import punk.core.World;
	import punk.Textplus;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class PasswordScreen extends World
	{
		//the background
		[Embed(source = 'res/silentbg.png')] private var imgBackground:Class;
		private var background:Backdrop = new Backdrop(imgBackground, 0, 0, false, false);
	
		//effects
		private var grungeEffect:GrungeEffect = new GrungeEffect();
		private var curtainEffect:Curtain = new Curtain(true, 3, false, null);
		
		//char selectors
		private var charOne:CharSelector;
		private var charTwo:CharSelector;
		private var charThree:CharSelector;
		
		private var selectorIndex:int = 0;
		
		//texts
		private var txtPassword:Textplus = new Textplus("Enter password\r\n", 104, 15);
		private var txtEscape:Textplus = new Textplus("ESC to go back\r\n", 104, 140);
		
		// 'enter' arrow
		[Embed(source = 'res/enter.png')] private var imgEnter:Class;
		private var sprEnter:Spritemap = FP.getSprite(imgEnter, 17, 11, false, false, 0, 0, true);
	
		
		//reference to the choosen level
		private var changeToLevel:XML;
		
		
		public function PasswordScreen() {
			trace("password");
		}
		
		override public function init():void {
			this.add(grungeEffect);
			this.add(curtainEffect);
			
			this.add(background);

			setupCharSelectors();
			setupTexts();
			
			curtainEffect.start(null);
		}
		
		private function setupTexts():void {
			txtPassword.setHitbox(208, 40, 0, 0);
			txtPassword.font = "Georgia";
			txtPassword.size = 14;
			txtPassword.color = 0xffffff;
			txtPassword.center();
			this.add(txtPassword);
			
			txtEscape.setHitbox(208, 40, 0, 0);
			txtEscape.font = "Georgia";
			txtEscape.size = 14;
			txtEscape.color = 0xffffff;
			txtEscape.center();
			//this.add(txtEscape);
			
			var a:Actor = new Actor();
			a.sprite = sprEnter;
			a.delay = 10;
			a.x = 170;
			a.y = 105;
			this.add(a);
		}
		
		
		private function setupCharSelectors():void {
				
			charOne = new CharSelector(50, 65);
			charTwo = new CharSelector(100, 65);
			charThree = new CharSelector(150, 65);
			
			this.add(charOne);
			this.add(charTwo);
			this.add(charThree);
			
		}
		
		
		override public function update():void {
			if (Input.pressedKey(Key.ESCAPE) && curtainEffect.stopped) {
				//back to title
				curtainEffect.start(gotoTitle)
			}
			
			if (Input.pressedKey(Key.LEFT)) {
				selectorIndex -= 1;
				if (selectorIndex < 0) {
					selectorIndex = 2;
				}
			}else if (Input.pressedKey(Key.RIGHT)) {
				selectorIndex += 1;
				selectorIndex %= 3;
			}
			
			switch(selectorIndex) {
				case 0: charOne.marked = true; charTwo.marked = false; charThree.marked = false; break;
				case 1: charOne.marked = false; charTwo.marked = true; charThree.marked = false; break;
				case 2: charOne.marked = false; charTwo.marked = false; charThree.marked = true; break;
			}
			
			
			if (Input.pressedKey(Key.ENTER)) {
				var pw:String = charOne.charText.text + charTwo.charText.text + charThree.charText.text;
				
				var lt:LevelTracker = LevelTracker.getInstance();
			
				var lvlFound:XML = lt.findLevelByPassword(pw);
				
				if (lvlFound != null) {
					curtainEffect.start(changeLevel);
					changeToLevel = lvlFound;
				}
			}
			
		}
		
		/**
		 * Callback function for the Curtain
		 */
		private function changeLevel():void {
			var lt:LevelTracker = LevelTracker.getInstance();
			lt.switchToLevelMsg(changeToLevel, true);
		}
		
		public function gotoTitle():void {
			trace("curtain stopped");
			FP.goto = new Titlescreen();
		}
		
		
	}

}