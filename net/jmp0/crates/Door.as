package net.jmp0.crates 
{
	import net.jmp0.crates.effects.PressdownLabel;
	import punk.Acrobat;
	import punk.core.Spritemap;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class Door extends Acrobat
	{
		//door sprite
		[Embed(source = 'res/env/door.png')] private var imgDoor:Class;
		private var sprDoor:Spritemap = FP.getSprite(imgDoor, 16, 16, true, false, 0, 0, true);

		//reference on the player
		private var player:Player;
		
		private var pressDownLabel:PressdownLabel = new PressdownLabel();
		
		public function Door(x:int, y:int) {
			this.x = x;
			this.y = y;
			
			this.depth = -30;
			this.setHitbox(16, 16, 0, 0);
			this.sprite = sprDoor;
			this.type = "door";
			
			FP.world.add(this.pressDownLabel);
		}
		
		
		override public function update():void {
			//if the player is in front of the door and pressed down -> next level
			if (getPlayer().x == x && getPlayer().y == y && Input.pressed("down")) {
				
				trace("level finished");
				var lt:LevelTracker = LevelTracker.getInstance();
				if (lt.hasNext()) {
					lt.switchToLevelMsg(lt.next(),false);
				}
			}
		}
		
		
		override public function render():void {
			drawSprite(sprite, 0, x, y, false, false);

			//player is standing in front of the door
			if (getPlayer().x == x && getPlayer().y == y) {
				//drawSprite(sprPressDown, 0, FP.camera.x, FP.camera.y, false, false);
				pressDownLabel.show();
			}else {
				pressDownLabel.hide();
			}
			
		}
		
		
		/**
		 * returns a reference on the player object
		 * @return Player
		 */
		private function getPlayer():Player {
			if (player == null) {
				player = FP.world.getTypeFirst("player") as Player;
			}
			return player;
		}
		
	}

}