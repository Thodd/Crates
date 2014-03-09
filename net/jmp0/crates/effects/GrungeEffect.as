package net.jmp0.crates.effects 
{
	import punk.Acrobat;
	import punk.core.Spritemap;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class GrungeEffect extends Acrobat
	{
		
		//grunge effect
		[Embed(source = '../res/title/oldmovie_lines2.png')] private var imgGrunge:Class;
		private var sprGrunge:Spritemap = FP.getSprite(imgGrunge, 208, 144, false, false, 0, 0, true);
		
		
		public function GrungeEffect() {
			x = 0;
			y = 0;
			this.delay = 7;
			this.depth = -1001;
			this.sprite = sprGrunge;
		}
		
		
		
	}

}