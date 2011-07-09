package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.ISelector;
	
	public class BaseSelector implements ISelector
	{
		protected var _numberOfSelections:uint = 0;
		
		protected var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		
		public function BaseSelector(numberOfSelections:uint = 0) {
			this._numberOfSelections = numberOfSelections;
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectSurvivors(specimens:Array):Array {
			throw new Error('Critical method not implemented');
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numberOfSelections():uint {
			return _numberOfSelections;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set numberOfSelections(value:uint):void {
			_numberOfSelections = value;
		}
		
		public function get seed():uint {
			return randomNumberGenerator.seed;
		}
		
		public function set seed(value:uint):void {
			randomNumberGenerator.seed = value;
		}
	}
}