package net.jmp0.crates 
{
	import flash.utils.ByteArray;
	import net.jmp0.crates.effects.BackToTitleLabel;
	import net.jmp0.crates.effects.Curtain;
	import net.jmp0.crates.effects.GrungeEffect;
	import punk.Backdrop;
	import punk.core.World;
	import punk.Textplus;
	import punk.Tilemap;
	import punk.util.*;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class GameLevel extends World
	{
		//Backgrounds
		[Embed(source = 'res/bgs/clouds_big.png')] private var imgBackClouds:Class;
		[Embed(source = 'res/bgs/clouds_white.png')] private var imgBackCloudsWhite:Class;
		private var bgClouds:Backdrop = new Backdrop(imgBackClouds, 0, 0, true, true);
		private var bgCloudsWhite:Backdrop =  new Backdrop(imgBackCloudsWhite, 0, 0, true, true);
		
		//The mapfile
		[Embed(source = 'levels/level1.oel', mimeType = "application/octet-stream")] public static const mapXMLFile:Class;
		private var mapXMLData:XML;
		
		//Tilemap + Tileset
		[Embed(source = 'res/tiles.png')] private var imgTileset:Class;
		public var tileMap:Tilemap;
		
		//Levelsize
		public var levelWidth:int=0;
		public var levelHeight:int=0;
		
		//reference to the player
		private var player:Player;
		
		//debugTexts
		private var dbgPlayerCoord:Textplus = new Textplus("px,py: ", FP.camera.x + 2, FP.camera.y + 2);
		private var dbgCarriedBrick:Textplus = new Textplus("crate: ", FP.camera.x + 2, FP.camera.y + 10);
		
		//grunge effect
		private var grungeEffect:GrungeEffect = new GrungeEffect();

		private var backToTitleLabel:BackToTitleLabel;
		
		
		public function GameLevel(mapXMLData:XML) {
			this.mapXMLData = mapXMLData;
		}
		
		
		override public function init():void {
			setupBackgrounds();
				
			setupTilemap();
			
			//adding debug texts
			//this.add(dbgCarriedBrick);
			//this.add(dbgPlayerCoord);
			
			this.add(grungeEffect);
		}
		
		
		/**
		 * setting up the backgrounds
		 */
		private function setupBackgrounds():void {
			bgClouds.depth = 300;
			bgCloudsWhite.depth = bgClouds.depth - 10;
			this.add(bgClouds);
			this.add(bgCloudsWhite);
		}
		
		
		/**
		 * debug stuff
		 */
		private function updateDebug():void {
			dbgPlayerCoord.text = "px, py: (" + player.x/16 + "," + player.y/16 + ")";
			dbgPlayerCoord.x = FP.camera.x + 2; dbgPlayerCoord.y = FP.camera.y + 2;
			dbgPlayerCoord.depth = -1000;
			
			if(player.crateCarried == null){
				dbgCarriedBrick.text = "crate: " + player.crateCarried;
			}else {
				dbgCarriedBrick.text = "crate: " + player.crateCarried.getID();
			}
			
			dbgCarriedBrick.x = FP.camera.x + 2; dbgCarriedBrick.y = FP.camera.y + 10;
			dbgCarriedBrick.depth = -1000;

		}
		
		
		/**
		 * Creating the tilemap based on the xml information
		 */
		private function setupTilemap():void {
			
			//Loading some level information from the xml file
			this.levelWidth = parseInt(mapXMLData.width);
			this.levelHeight = parseInt(mapXMLData.height);
			
			//initialising the tilemap
			tileMap = new Tilemap(imgTileset, levelWidth, levelHeight, 16, 16);
			
			//Loading tiles from xml
			var t:XML;
			for each (t in mapXMLData.tiles.tile) {
				tileMap.setTile(t.@x / 16, t.@y / 16, parseInt(t.@id)+1);
			}
			//loading objects from xml
			var o:XML;
			for each (o in mapXMLData.objects.player) {
				this.player = new Player(o.@x, o.@y);
				this.add(this.player);
			}
			for each (o in mapXMLData.objects.crate) {
				trace("crate at " + parseInt(o.@x)/16 +"," + parseInt(o.@y)/16);
				this.add(new Crate(o.@x, o.@y));
			}
			for each (o in mapXMLData.objects.door) {
				trace("door at " + parseInt(o.@x)/16 +"," + parseInt(o.@y)/16);
				this.add(new Door(o.@x, o.@y));
			}
			
			//tilemap options
			tileMap.x = 0;
			tileMap.y = 0;
			tileMap.depth = -20;
			tileMap.type = "tiles";
			
			//camera stuff
			FP.camera.setBounds(0, 0, levelWidth, levelHeight);
			
			//and finally we add the tilemap to the world
			this.add(tileMap);
			
		}
		
		
		override public function update():void {
			
			//debugstuff
			//updateDebug();
			grungeEffect.x = FP.camera.x;
			grungeEffect.y = FP.camera.y;
			
			//Moving the backdrops
			bgClouds.x += 0.5;
			bgCloudsWhite.x += 1;
			
			if (Input.pressedKey(Key.ENTER)) {
				/*FP.engine.scaleX = 1 + (FP.engine.scaleX) % 3;
				FP.engine.scaleY = 1 + (FP.engine.scaleY) % 3;*/
			}else if (Input.pressedKey(Key.R)) {
				//Restart the level
				LevelTracker.getInstance().restartLevel(true);
			}else if (Input.pressedKey(Key.M)) {
				//Mute/turnup music
				if (!MusicPlayer.muted) {
					MusicPlayer.mute();
				}else if (MusicPlayer.muted) {
					MusicPlayer.turnUp();
				}
			}else if (Input.pressedKey(Key.ESCAPE) && backToTitleLabel == null) {
				//Go back to the main menu
				backToTitleLabel = new BackToTitleLabel(backToTitleCallback);
				this.add(backToTitleLabel);
				player.active = false;
				backToTitleLabel.show();
			}
			
		}
		
		
		public function backToTitleCallback():void {
			trace("triggered backtotitlecallback");
			player.active = true;
		}

		
	}

}