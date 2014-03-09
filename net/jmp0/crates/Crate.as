package net.jmp0.crates  
{
	import punk.Acrobat;
	import punk.core.Spritemap;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class Crate extends Acrobat
	{
		//static instance counter
		public static var gID:int = 0;
		
		//unique id for each crate
		public var id:int = 0;

		
		[Embed(source = 'res/env/crate.png')] private var imgCrate:Class;
		private var sprCrate:Spritemap = FP.getSprite(imgCrate, 16, 16, true, false, 0, 0, true);
		
		//indicates if this crate is carried by the player
		public var isCarried:Boolean = false;
		//reference to the player
		public var player:Player;
		
		//indicates if this crate is floating above the ground without falling down
		public var isFloating:Boolean = true;
		
		
		public function Crate(x:int, y:int) {
			this.x = x;
			this.y = y;
			
			this.depth = -30;
			this.setHitbox(16, 16, 0, 0);
			this.sprite = sprCrate;
			this.type = "crate";
			
			this.id = Crate.gID;
			
			Crate.gID += 1;
		}
		
		
		override public function update():void {
			
			doGravity();
			
			//debug stuff
			if (Input.pressedKey(Key.CONTROL)) {
				trace(this.getID());
			}
		}
		
		
		/**
		 * Moving the crate down to the ground if there is nothing below it and the player is not carrying the crate
		 */
		public function doGravity():void {
			var destroyed:Boolean = false;
			
			//super simple gravity ;)
			while(!isCarried && !isFloating && !collide("tiles", x, y + 1) && !collide("crate", x, y+1) && !destroyed) {
				y += 1;
				
				//destroying the crate if it fell of the map
				if (y > (FP.world as GameLevel).levelHeight) {
					destroyed = true;
					FP.world.remove(this);
				}
			}
		}

		
		public function follow():void {
			//moving the block if it was picked up
			if (isCarried && player != null) {
				//but only if there is a free space in front of the crate
				if(!collide("tiles", player.x, player.y - 16) && !collide("crate", player.x, player.y-16)){
					x = player.x;
					y = player.y - 16;
				}else {
					//otherwise the crate is dropped
					isCarried = false;
					isFloating = false;
					player.crateCarried = null;
				}
			}
		}
		
		
		/**
		 * This is called if the player picksup the crate
		 * @param	player
		 */
		public function pickup(player:Player):void {
			isCarried = true;
			isFloating = false;
			this.player = player;
			player.crateCarried = this;
		}
		
		
		/**
		 * This is called if the player drops the crate
		 */
		public function drop(xmod:int = 0):void {
			x += xmod;
			isCarried = false;
			isFloating = false;
			player.crateCarried = null;
			this.player = null;
		}
		
		
		public function getID():String {
			return "" + this + ", #" + this.id + " at (" + x/16 + "," + y/16 +")";
		}
		
	}

}