package net.jmp0.crates
{

	import punk.Actor;
	import punk.core.Spritemap;
	import punk.Textplus;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class CharSelector extends Actor
	{
		//the background
		[Embed(source = 'res/indicator.png')] private var imgIndicator:Class;
		private var sprIndicator:Spritemap = FP.getSprite(imgIndicator, 36, 56, false, false, 0, 0, true);
	
		private var choosenChar:int = 0;
		
		private var alphabet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		
		public var charText:Textplus;
		
		public var marked:Boolean = false;

		private var enterText:Textplus = new Textplus("Press 'Enter' to confirm");
		
		public function CharSelector(x:int, y:int) {
			this.x = x;
			this.y = y;

			charText = new Textplus(alphabet.charAt(choosenChar), x, y);
			charText.font = "Georgia";
			charText.size = 16;
			charText.color = 0xffffff;

			this.sprite = sprIndicator;
			this.delay = 8;
			
			FP.world.add(charText);

		}
		
		
		override public function update():void {
			if(marked){
				if (Input.pressedKey(Key.UP)) {
					upWasPressed();
				}else if (Input.pressedKey(Key.DOWN)) {
					downWasPressed();
				}
			}
		}
		
		
		public function upWasPressed():void {
			choosenChar = (choosenChar + 1) % alphabet.length;
			charText.text = alphabet.charAt(choosenChar);
		}
		
		public function downWasPressed():void {
			choosenChar = choosenChar - 1;
			choosenChar = (choosenChar < 0) ? (alphabet.length-1) : choosenChar;
			charText.text = alphabet.charAt(choosenChar);
		}

		
		override public function render():void {
			this.updateImage(sprite.number);
			if(marked){
				drawSprite(sprite, image, x - 11, y - 15, false, false);
			}
		}
	}

}