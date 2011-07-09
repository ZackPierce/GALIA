package galia.base
{
	import galia.core.IPopulation;
	
	public class Population implements IPopulation
	{
		private var _specimens:Array = [];
		
		public function Population() {
		}
		
		public function get specimens():Array {
			return _specimens;
		}
		
		public function set specimens(value:Array):void {
			_specimens = value;
		}
	}
}