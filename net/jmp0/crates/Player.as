package net.jmp0.crates 
{
	import punk.Acrobat;
	import punk.core.Alarm;
	import punk.core.Spritemap;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class Player extends Acrobat
	{
		[Embed(source = 'res/char/goh-carrying.png')] private var imgCarrying:Class;
		[Embed(source = 'res/char/goh-walking.png')] private var imgWalking:Class;
		
		private var sprCarrying:Spritemap = FP.getSprite(imgCarrying, 16, 16, true, false, 0, 0, true);
		private var sprWalking:Spritemap = FP.getSprite(imgWalking, 16, 16, true, false, 0, 0, true);
		
		//Moving variables
		private var movingDir:int = 1;
		//Direction constants
		private static const IDLE:int = -1;
		private static const LEFT:int = 1;
		private static const RIGHT:int = 3;
		private static const UP:int = 0;
		private static const DOWN:int = 2;
	
		//the crate the player is carrying, if any
		public var crateCarried:Crate;
		
		//this variable indicates if the player is looking around
		public var lookingAround:Boolean = false;
		
		//indicates if the player can move...
		private var canMove:Boolean = true;
		
		
		public function Player(x:int, y:int) {
			
			this.x = x;
			this.y = y;
			
			this.depth = -30;
			this.setHitbox(16, 16, 0, 0);
			this.delay = 15;
			this.sprite = sprWalking;
			this.type = "player";
			
			setupKeybinding();

		}
		
		
		private function setupKeybinding():void {
			Input.define("left", Key.LEFT);
			Input.define("right", Key.RIGHT);
			Input.define("up", Key.UP);
			Input.define("down", Key.DOWN);
			Input.define("look", Key.SHIFT);
		}
		
		
		override public function update():void {
			
			if(canMove){
				checkInput();
			}
			
			adjustSprite();
			
			doGravity();
			
			if(!lookingAround){
				adjustCamera();
			}
			
		}
		
		
		/**
		 * Adjusting the player sprite according to the "carrying-state" o.o
		 */
		private function adjustSprite():void {
			if (crateCarried == null) {
				this.sprite = sprWalking;
			}else {
				this.sprite = sprCarrying;
			}
		}
		
		
		/**
		 * super simple gravity
		 */
		private function doGravity():void {
			var died:Boolean = false;
			
			while(!collide("tiles", x, y + 1) && !collide("crate", x, y + 1) && !died) {
				y += 1;
				
				if (y > (FP.world as GameLevel).levelHeight) {
					died = true; //breaking the while loop
					var lt:LevelTracker = LevelTracker.getInstance();
					lt.restartLevel(true);
				}
			}
			
			//keeping the crate above the player after invoking the gravity
			if (crateCarried != null) {
				crateCarried.follow();
			}
		}
		
		
		/**
		 * Checks for Input
		 *  - Moving player
		 *  - picking up/dropping crates
		 */		
		private function checkInput():void {
			
			var moved:Boolean = false;
			var xmod:int = 0;
			var ymod:int = 0;
			
			var heldDown:Boolean = false;
			
			
			//ok now this hard return sucks but I'm too lazy to refactor, the code is
			//already wierd :)
			if (Input.check("look")) {
				lookingAround = true;
				moveCamera();
				return; //boo ;(
			}else {
				lookingAround = false;
			}
			
			
			//checking if the UP key was pressed
			//climbing up bricks/crates
			if (Input.pressed("up") || Input.check("up")) {
				
				ymod = -16;
				
				//if there is a brick/crate above the player, no climbing up, nothing to be done
				var crateAbove:Crate = collide("crate", x, y + ymod) as Crate;
				if (crateAbove != crateCarried || collide("tiles", x, y + ymod)) {
					return;
				}
				
				//determining the facing direction  of the player
				if (movingDir == Player.LEFT) {
					xmod = -16;
				}else {
					xmod = 16;
				}

				//moving up, only if there is a brick/crate to stand on
				//and if there is no brick/crate above the 
				if ( (collide("crate", x + xmod, y) || collide("tiles", x + xmod, y) ) && //crate/brick in front of the player
					!(collide("crate", x + xmod, y + ymod) || collide("tiles", x + xmod, y + ymod)) ){ //no crate/brick occupying the destination
					y += ymod;
					x += xmod;
				}
				
				xmod = 0;
				ymod = 0;
				
				moved = true;
				
			}else if (Input.pressed("left") || Input.check("left")) { //moving horizontal
				movingDir = Player.LEFT;
				xmod = -16;
				
			}else if (Input.pressed("right") || Input.check("right")) { //as above
				movingDir = Player.RIGHT;
				xmod = 16;
			}
			
			//normal horizontal movement ONLY, no moving up!
			if (!collide("tiles", x + xmod, y) && !collide("crate", x + xmod, y)){
				x += xmod;
				moved = true;
			}
			
			//The Down key let's us pickup a crate
			if (Input.pressed("down")) {
				
				//determining the facing direction of the player
				if (movingDir == Player.LEFT) {
					xmod = -16;
				}else {
					xmod = 16;
				}
				
				if (crateCarried == null) {
					//trying to pickup a crate
					tryToPickupCrate(xmod);
				}else {
					//trying to drop a crate
					tryToDropCrate(xmod);
				}
			}
			
			
			//checking if the key was held down
			if (Input.check("left") || Input.check("right") || Input.check("up")) {
				heldDown = true;
			}
			
			
			//checking if there was a movement and if a key is held down -> set an alarm to slow down the movement
			if (moved && heldDown) {
				afterMove();
			}
			
		}

		
		/**
		 * Moving the camera around the map
		 */
		private function moveCamera():void {
			if (Input.pressed("left")) {
				FP.camera.moveTo(FP.camera.x - 16, FP.camera.y);
			}else if (Input.pressed("right")) {
				FP.camera.moveTo(FP.camera.x + 16, FP.camera.y);
			}else if (Input.pressed("up")) {
				FP.camera.moveTo(FP.camera.x, FP.camera.y - 16);
			}else if (Input.pressed("down")) {
				FP.camera.moveTo(FP.camera.x, FP.camera.y + 16);
			}
		}
		
		
		/**
		 * Trying to pickup a crate based on several conditions
		 */
		private function tryToPickupCrate(xmod:int = 0):void {

			//checking if there's a crate in front of the player
			var possibleCrate:Crate = collide("crate", x + xmod, y) as Crate;
			
			if (possibleCrate != null && //collision with a crate right in front
				!( collide("tiles", x + xmod, y - 16) || collide("crate",x+xmod, y-16) ) && //no collision with anything on top of the crate
				!( collide("tiles", x, y-16) || collide("crate", x, y-16) ) ) { //no collision over the player
				
				possibleCrate.pickup(this); //picking up the crate

			}
			
		}
		
		
		/**
		 * Trying to drop a crate based on several conditions
		 */
		private function tryToDropCrate(xmod:int = 0):void {

			//checking if there is a free place to drop the crate
			if (!collide("tiles", x + xmod, y - 16) && !collide("crate", x + xmod, y - 16)) {
				crateCarried.drop(xmod);
			}

		}
		
		
		/**
		 * executed after a movement, sets a timer to slow down input handling
		 */
		public function afterMove():void {
			trace("player moved to: (" + x/16 + "," + y/16 + ")");
			canMove = false;
			this.addAlarm(new Alarm(5, resetMovement, Alarm.ONESHOT));
		}
		
		/**
		 * enables the movement, used as a callback function for the alarm triggered by "afterMove()" 
		 */
		public function resetMovement():void {
			canMove = true;
		}
		
		
		/**
		 * Keeping the camera centered
		 */
		private function adjustCamera():void {
			FP.camera.moveTo(x - 96, y - 64);
		}
		
		
		/**
		 * Drawing the sprite and stuff
		 */
		override public function render():void {
			this.updateImage(sprite.number);
			
			var flipX:Boolean = false;

			switch(movingDir) {
				case Player.LEFT: flipX = false; break;
				case Player.RIGHT: flipX = true; break;
			}
				
			drawSprite(sprite, image, x, y, flipX, false);
		}
		
		
		/**
		 * checking if the player is aligned to the grid
		 */
		public function isAligned(gridWidth:int, gridHeight:int):Boolean{
			return (this.x % gridWidth) == 0 && (this.y % gridHeight) == 0;
		}
		
		
		/**
		 * aligning the entity to the grid
		 */
		public function align(gridWidth:int, gridHeight:int):void {
			this.x = int(this.x / gridWidth) * gridWidth;
			this.y = int(this.y / gridHeight) * gridHeight;
		}
		
	}

}