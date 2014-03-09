package net.jmp0.crates.effects 
{
	import punk.Acrobat;
	import punk.core.Spritemap;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class Credits extends Acrobat
	{
		//slideshow
		[Embed(source = '../res/credits.png')] private var imgCredits:Class;
		private var sprCredits:Spritemap = FP.getSprite(imgCredits, 208, 144, false, false, 0, 0, true);

		public function Credits() 
		{
			this.sprite = sprCredits;
			this.delay = 120;
		}
		
	}

}