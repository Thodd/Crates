package net.jmp0.crates.effects 
{
	import punk.Acrobat;
	import punk.core.Spritemap;
	import punk.Textplus;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class PressdownLabel extends Acrobat
	{
				
		//The SilentBG
		[Embed(source = '../res/silentbg.png')] private var imgBg:Class;
		private var sprBg:Spritemap = FP.getSprite(imgBg, 0, 0, false, false, 0, 0, true);

		private var txt:Textplus = new Textplus("Next scene:", 104, 70);
		
		public var arrowDown:ArrowDown = new ArrowDown();
		
		public function PressdownLabel() {
			this.depth = -900;
			this.visible = false;
			setupTxt();
		}
		
		
		private function setupTxt():void {
			txt.setHitbox(208, 40, 0, 0);
			txt.font = "Georgia";
			txt.size = 16;
			txt.color = 0xffffff;
			txt.depth = -901;
			txt.center();
			
			FP.world.add(txt);
		}
		
		
		public function show():void {
			this.visible = true;
			arrowDown.visible = true;
			txt.visible = true;
		}
		
		public function hide():void {
			this.visible = false;
			arrowDown.visible = false;
			txt.visible = false;
		}
		
		override public function render():void {
			x = FP.camera.x;
			y = FP.camera.y;
			arrowDown.x = x + 97;
			arrowDown.y = y + 80;
			txt.x = x + 104;
			txt.y = y + 70
			drawSprite(sprBg, 0, x, y, false, false);
		}
		
	}

}