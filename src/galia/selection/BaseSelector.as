package galia.selection
{
	import galia.core.IRandomNumberGenerator;
	import galia.core.ISelector;
	import galia.math.MathRandomNumberGenerator;
	
	public class BaseSelector implements ISelector
	{
		protected var _numberOfSelections:uint = 0;
		
		private var _randomNumberGenerator:IRandomNumberGenerator = new MathRandomNumberGenerator();
		
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
		
		public function get randomNumberGenerator():IRandomNumberGenerator {
			return _randomNumberGenerator;
		}
		
		public function set randomNumberGenerator(value:IRandomNumberGenerator):void {
			_randomNumberGenerator = value;
		}
	}
}