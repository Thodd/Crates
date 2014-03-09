package net.jmp0.crates 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import punk.util.Input;
	/**
	 * ...
	 * @author Thodd
	 */
	public class LevelTracker
	{
		//singleton instance
		private static var instance:LevelTracker;
		
		//This List and the corresponding pointer tell me which level the player is currently in
		private static var allLevelsAsXMLFiles:Array = new Array();
		private static var allLevels:Array = new Array();
		private static var currentLevel:int = -1;
		
		//Embedding all levelfiles and adding them to the static levelarray
		[Embed(source = 'levels/Level1.oel', mimeType = "application/octet-stream")] public static const Level_01_XMLFile:Class;
		allLevelsAsXMLFiles[0] = Level_01_XMLFile;
		[Embed(source = 'levels/Level2.oel', mimeType = "application/octet-stream")] public static const Level_02_XMLFile:Class;
		allLevelsAsXMLFiles[1] = Level_02_XMLFile;
		[Embed(source = 'levels/Level3.oel', mimeType = "application/octet-stream")] public static const Level_03_XMLFile:Class;
		allLevelsAsXMLFiles[2] = Level_03_XMLFile;
		[Embed(source = 'levels/Level3-1.oel', mimeType = "application/octet-stream")] public static const Level_3p1_XMLFile:Class;
		allLevelsAsXMLFiles[3] = Level_3p1_XMLFile;
		[Embed(source = 'levels/Level4.oel', mimeType = "application/octet-stream")] public static const Level_04_XMLFile:Class;
		allLevelsAsXMLFiles[4] = Level_04_XMLFile;
		[Embed(source = 'levels/Level5.oel', mimeType = "application/octet-stream")] public static const Level_05_XMLFile:Class;
		allLevelsAsXMLFiles[5] = Level_05_XMLFile;
		[Embed(source = 'levels/Level6.oel', mimeType = "application/octet-stream")] public static const Level_06_XMLFile:Class;
		allLevelsAsXMLFiles[6] = Level_06_XMLFile;
		[Embed(source = 'levels/Level7.oel', mimeType = "application/octet-stream")] public static const Level_07_XMLFile:Class;
		allLevelsAsXMLFiles[7] = Level_07_XMLFile;
		[Embed(source = 'levels/Level8.oel', mimeType = "application/octet-stream")] public static const Level_08_XMLFile:Class;
		allLevelsAsXMLFiles[8] = Level_08_XMLFile;
		[Embed(source = 'levels/Level9.oel', mimeType = "application/octet-stream")] public static const Level_09_XMLFile:Class;
		allLevelsAsXMLFiles[9] = Level_09_XMLFile;
		[Embed(source = 'levels/Level10.oel', mimeType = "application/octet-stream")] public static const Level_10_XMLFile:Class;
		allLevelsAsXMLFiles[10] = Level_10_XMLFile;
		[Embed(source = 'levels/Level11.oel', mimeType = "application/octet-stream")] public static const Level_11_XMLFile:Class;
		allLevelsAsXMLFiles[11] = Level_11_XMLFile;
		
		
		/**
		 * When the LevelTracker is constructed all XML Files are transformed to XML objects
		 */
		public function LevelTracker() {
			
			for (var i:int = 0; i < allLevelsAsXMLFiles.length; i++) {
				var file:ByteArray = new allLevelsAsXMLFiles[i];
				var str:String = file.readUTFBytes(file.length);
				var xmlData:XML = new XML(str);
				
				allLevels.push(xmlData);
			}
			allLevelsAsXMLFiles = null;
			
		}
		
		
		/**
		 * returns the single instance of the LevelTracker
		 * @return the instance
		 */
		public static function getInstance():LevelTracker {
			if (instance == null) {
				//set to -1 because when we call next() for the first time we want to get the Level at position 0
				currentLevel = -1;
				instance = new LevelTracker();
			}
			return instance;
		}
		
		
		/**
		 * Delivers the next level following the current one or the first level if we reached the last level
		 * and increments the level pointer
		 * This method doesn't switch the level for you, it only returns the next level in line as a XML object
		 * 
		 * @return the next level as a XML file
		 */
		public function next():XML {
			currentLevel += 1;
			if(currentLevel < allLevels.length){
				return allLevels[currentLevel];
			}else {
				trace("you win all");
				currentLevel = 0;
				return null;
			}
		}
		
		/**
		 * Returns if there are still some levels left to play
		 * @return mh yeah look above...
		 */
		public function hasNext():Boolean {
			return (currentLevel < allLevels.length);
		}
		
		
		/**
		 * Returns a specific level represented by it's position in the global levellist
		 * @param	i The position of the level you want to get
		 * @return a reference to a XML file containing the level information, this is used by GameLevel
		 * @see GameLevel
		 */
		public function getLevel(i:int):XML {
			if(i <= allLevels.length){
				return allLevels[i];
			}else {
				return allLevels[0];
			}
		}
		
		/**
		 * Returns the number of the currentLevel
		 * @return the iterator position
		 */
		public function getCurrentLevelNumber():int {
			return currentLevel;
		}
		
		
		/**
		 * Finds a level by the password associated with the level
		 * @param	pw The password used to find the level
		 * @return a XML object containing the level information OR null if none was found
		 */
		public function findLevelByPassword(pw:String):XML{
			for (var i:int = 0; i < allLevels.length; i++) {
				trace(allLevels[i].@password);
				
				if (allLevels[i].@password == pw) {
					setCurrentLevel(i); //ok this sucks, the currentLevel is set before anything happens, can become a problem :(
					return allLevels[i];
				}
			}
			return null;
		}
		
		
		
		/**
		 * Sets the currentLevel pointer to a specific position, this method doesn't switch to that level though...
		 * It's more like a debug function
		 * 
		 * @param	i the new position of the level pointer
		 * @return the XML the level pointer points to
		 */
		public function setCurrentLevel(i:int):XML {
			if (i <= allLevels.length) {
				currentLevel = i;
			}
			return allLevels[currentLevel];
		}
		
		
		/**
		 * Returns the XML File for the current level
		 * @return the XML file for the level
		 */
		public function getCurrentLevel():XML {
			return allLevels[currentLevel];
		}
		
		
		/**
		 * This method actually starts the level you handed over to it
		 * @param	xmlData the level you want to switch to
		 */
		public function switchToLevel(xmlData:XML):void {
			FP.goto = new GameLevel(xmlData);
		}
			
		
		/**
		 * Switching to a "LevelChangeScreen"
		 * @param	xmlData
		 */
		public function switchToLevelMsg(xmlData:XML, curtain:Boolean = false):void {
			if(xmlData != null){
				FP.goto = new LevelChangeScreen(xmlData, curtain); //Making a "Prescreen" here
			}else {
				//no more levels :(
				FP.goto = new FinScreen();
			}
		}
		
		
		/**
		 * restarts the current level
		 */
		public function restartLevel(withMessage:Boolean):void {
			if (withMessage) {
				switchToLevelMsg(getCurrentLevel());
			}else {
				switchToLevel(getCurrentLevel());
			}
		}
		
	}

}