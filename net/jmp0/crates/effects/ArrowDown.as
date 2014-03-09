package net.jmp0.crates.effects 
{
	import punk.Acrobat;
	import punk.core.Spritemap;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class ArrowDown extends Acrobat
	{
		//The pressdown thingy
		[Embed(source = '../res/arrow_down.png')] private var imgArrowDown:Class;
		private var sprArrowDown:Spritemap = FP.getSprite(imgArrowDown, 14, 14, false, false, 0, 0, true);
		
		public function ArrowDown() {
			this.sprite = sprArrowDown;
			this.delay = 7;
			this.depth = -901;
			FP.world.add(this);
		}
		
	}

}