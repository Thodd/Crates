package net.jmp0.crates 
{
	/**
	 * ...
	 * @author Thodd
	 */
	public class MusicPlayer
	{
		
		//music
		[Embed(source = 'res/snd/EasyWinners.mp3')] private static var musicEasyWinners:Class;

		public static var musicPlaying:Boolean = false;
		public static var musicPaused:Boolean = false;		
		public static var muted:Boolean = false;

		public function MusicPlayer() {

		}
		
		
		public static function start():void {
			//starting the music
			if (!musicPlaying) {
				FP.musicPlay(musicEasyWinners, true, null);
				musicPlaying = true;
				musicPaused = false;
			}
		}
		
		
		public static function stop():void {
			if (musicPlaying) {
				FP.musicStop();
				musicPlaying = false;
				musicPaused = false;
			}
		}
		
		public static function pause():void {
			if(musicPlaying){
				FP.musicPause();
				musicPlaying = false;
				musicPaused = true;
			}
		}
		
		public static function resume():void {
			if(!musicPlaying){
				FP.musicResume();
				musicPlaying = true;
				musicPaused = false;
			}
		}
		
		public static function mute():void {
			FP.musicVolume = 0;
			muted = true;
		}
		
		public static function turnUp():void {
			FP.musicVolume = 1;
			muted = false;
		}
		
	}

}