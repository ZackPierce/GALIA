package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.IPopulation;
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	
	public class RouletteWheelSelector implements ISelector
	{
		private var _numberOfSelections:uint;
		
		private var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		
		public function RouletteWheelSelector(numberOfSelections:Number = 0)
		{
			this.numberOfSelections = numberOfSelections;
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
			this._numberOfSelections = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectSurvivors(specimens:Array):Array {
			if (!specimens || specimens.length == 0 || numberOfSelections == 0) {
				return [];
			}
			
			var localSpecimens:Array = specimens.concat();
			var selectedSpecimens:Array = [];
			SelectionUtil.calculateNormalizedAndAccumulatedNormalizedFitnessesValues(localSpecimens);
			
			while (selectedSpecimens.length < numberOfSelections) {
				var spinPoint:Number = randomNumberGenerator.random();
				// TODO - implement more efficient binary search
				for each (var specimen:ISpecimen in localSpecimens) {
					if (specimen.accumulatedNormalizedFitness >= spinPoint) {
						selectedSpecimens.push(specimen);
						break;
					}
				}
			}
			return selectedSpecimens;
		}
		
		public function set seed(value:uint):void {
			randomNumberGenerator.seed = value;
		}
	}
}