package net.jmp0.crates.effects
{
	import net.jmp0.crates.effects.Curtain;
	import punk.Acrobat;
	import punk.core.Spritemap;
	import punk.core.World;
	/**
	 * ...
	 * @author Thodd
	 */
	public class Fin extends Acrobat
	{
		//slideshow
		[Embed(source = '../res/fin.png')] private var imgFin:Class;
		private var sprFin:Spritemap = FP.getSprite(imgFin, 208, 144, false, false, 0, 0, true);

		public var curtainEffect:Curtain;
		
		private var curtainDown:Boolean = false;
		
		private var finSplash:FinSplash = new FinSplash();
		
		public function Fin() {
			this.sprite = sprFin;
			this.delay = 120;
		}	
		
		
		override public function update():void {
			FP.musicVolume -= 0.0025;
			if (image == 3 && !curtainDown) {
				curtainEffect.start(curtainFinished);
			}
		}
		
		
		public function curtainFinished():void {
			curtainDown = true;
			FP.world.add(finSplash);
			finSplash.start();
			//FP.goto = new Titlescreen();
		}

	}

}