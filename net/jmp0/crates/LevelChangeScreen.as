package net.jmp0.crates 
{
	import net.jmp0.crates.effects.ArrowDown;
	import net.jmp0.crates.effects.Curtain;
	import net.jmp0.crates.effects.GrungeEffect;
	import punk.Backdrop;
	import punk.core.Entity;
	import punk.core.Spritemap;
	import punk.core.World;
	import punk.Textplus;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class LevelChangeScreen extends World
	{
		//Embedding the font
		[Embed(source = 'res/fonts/georgia.ttf', fontFamily = 'Georgia')] private var fontGeorgia:Class;
		
		//the background
		[Embed(source = 'res/silentbg.png')] private var imgBackground:Class;
		private var background:Backdrop = new Backdrop(imgBackground, 0, 0, false, false);

		//the level this screen will lead to
		public var mapXMLData:XML;
		
		//some text
		private var txtLeveltitle:Textplus = new Textplus("A country road.", 104, 70);
		private var txtPassword:Textplus = new Textplus("Password: ", 104, 135);
		
		//effects
		private var grungeEffect:GrungeEffect = new GrungeEffect();
		private var curtainEffect:Curtain;
		private var arrowDown:ArrowDown = new ArrowDown();
		
		private var curtainUsage:Boolean = false;
		private var curtainUp:Boolean = true;
		
		public function LevelChangeScreen(mapXMLData:XML, curtainUsage:Boolean = false) {
			this.mapXMLData = mapXMLData;
			this.curtainUsage = curtainUsage;
			
			if (curtainUsage) {
				curtainUp = false;
				curtainEffect = new Curtain(true, 3, false, null);
			}
			
		}
		
		override public function init():void {
			this.add(background);
			
			trace("levelchangescreen init() - " + mapXMLData.@title);
			FP.camera.x = 0;
			FP.camera.y = 0;
			
			setupTitle();
			setupPassword();
			
			this.add(grungeEffect);
			
			this.add(arrowDown);
			arrowDown.x = 97;
			arrowDown.y = 80;
			
			//if we what to have a curtain shown -> add the effect and start its movement
			if (curtainUsage) {
				this.add(curtainEffect);
				curtainEffect.start(curtainFinished);
			}
			
		}
		
		
		/**
		 * Callback function for the curtain
		 */
		private function curtainFinished():void {
			curtainUp = true;
		}
		
		
		private function setupTitle():void {
			txtLeveltitle.setHitbox(208, 40, 0, 0);
			txtLeveltitle.text = mapXMLData.@title;
			txtLeveltitle.font = "Georgia";
			txtLeveltitle.size = 16;
			txtLeveltitle.color = 0xffffff;
			
			txtLeveltitle.center();
			
			this.add(txtLeveltitle);
		}
		
		
		private function setupPassword():void {
			txtPassword.setHitbox(208, 40, 0, 0);
			txtPassword.text = "Password: " + mapXMLData.@password;
			txtPassword.font = "Georgia";
			txtPassword.size = 14;
			txtPassword.color = 0xffffff;
			
			txtPassword.center();
			
			this.add(txtPassword);
		}
		
		
		override public function update():void {
			//Switching the level when the curtain is lifted and the
			if (Input.pressedKey(Key.DOWN) && curtainUp) {
				//var lt:LevelTracker = LevelTracker.getInstance();
				//lt.switchToLevel(mapXMLData);
				FP.goto = new GameLevel(mapXMLData);
			}
			
			if (Input.pressedKey(Key.ENTER)) {
				trace(this.getClass(Entity));
			}
		}
		
	}

}