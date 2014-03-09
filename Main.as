package
{
	import net.jmp0.crates.*;
	import punk.core.*;
	import punk.util.*;
	import punk.*;
	
	[SWF(width = "416", height = "288")]
	
	public class Main extends Engine {
		
		public function Main(){
			showSplash(0x262626, 0xA0A0A0, 0, false);
			super(208, 144, 40, 2, Titlescreen);
		}
		
	}
	
}