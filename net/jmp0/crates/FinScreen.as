package net.jmp0.crates 
{
	import net.jmp0.crates.effects.Curtain;
	import net.jmp0.crates.effects.Fin;
	import net.jmp0.crates.effects.GrungeEffect;
	import punk.core.World;
	
	/**
	 * ...
	 * @author Thodd
	 */
	public class FinScreen extends World
	{
		
		private var fin:Fin = new Fin();
		
		private var grungeEffect:GrungeEffect = new GrungeEffect();
		public var curtainEffect:Curtain = new Curtain(false, 1, false, null);
		
		public function FinScreen(){
			
		}
		
		override public function init():void {
			FP.camera.x = 0;
			FP.camera.y = 0;
			
			this.add(grungeEffect);
			this.add(curtainEffect);
			this.add(fin);
			fin.curtainEffect = curtainEffect;
		}
		
	}

}