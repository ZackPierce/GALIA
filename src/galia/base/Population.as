package galia.base
{
	import galia.core.IPopulation;
	
	public class Population implements IPopulation
	{
		private var _generationIndex:uint;
		private var _id:String;
		private var _specimens:Array = [];
		
		public function Population(generationIndex:uint = 0, id:String = null, specimens:Array = null) {
			this._generationIndex = generationIndex;
			this._id = id;
			if (specimens) {
				this._specimens = specimens;
			}
		}
		
		public function get generationIndex():uint {
			return _generationIndex;
		}
		
		public function set generationIndex(value:uint):void {
			_generationIndex = value;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		public function get specimens():Array {
			return _specimens;
		}
		
		public function set specimens(value:Array):void {
			_specimens = value;
		}
	}
}