package net.jmp0.crates 
{
	import net.jmp0.crates.effects.Credits;
	import net.jmp0.crates.effects.Curtain;
	import net.jmp0.crates.effects.GrungeEffect;
	import punk.Backdrop;
	import punk.core.World;
	import punk.Textplus;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class CreditScreen extends World
	{
		//the background
		[Embed(source = 'res/silentbg.png')] private var imgBackground:Class;
		private var background:Backdrop = new Backdrop(imgBackground, 0, 0, false, false);
	
		//effects
		private var grungeEffect:GrungeEffect = new GrungeEffect();
		private var curtainEffect:Curtain = new Curtain(true, 3, false, null);
		
		//texts
		private var txtEscape:Textplus = new Textplus("ESC to go back\r\n", 104, 140);
		private var txtCredit:Textplus = new Textplus("Credits\r\n", 104, 15);

		public function CreditScreen() {
			trace("credit");
		}
		
		override public function init():void {
			this.add(grungeEffect);
			this.add(curtainEffect);
			
			this.add(background);
			
			setupTexts();
			
			this.add(new Credits());
			
			curtainEffect.start(null);
		}
		
				
		private function setupTexts():void {
			txtCredit.setHitbox(208, 40, 0, 0);
			txtCredit.font = "Georgia";
			txtCredit.size = 14;
			txtCredit.color = 0xffffff;
			txtCredit.center();
			this.add(txtCredit);
			
			txtEscape.setHitbox(208, 40, 0, 0);
			txtEscape.font = "Georgia";
			txtEscape.size = 14;
			txtEscape.color = 0xffffff;
			txtEscape.center();
			//this.add(txtEscape);
		}
		
		
		override public function update():void {
			if (Input.pressedKey(Key.ESCAPE) && curtainEffect.stopped) {
				//back to title
				curtainEffect.start(gotoTitle);
			}
		}
		
		
		public function gotoTitle():void {
			trace("curtain stopped");
			FP.goto = new Titlescreen();
		}
		
	}

}