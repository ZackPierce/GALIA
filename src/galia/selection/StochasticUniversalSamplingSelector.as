package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.IPopulation;
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	
	public class StochasticUniversalSamplingSelector implements ISelector
	{
		private var _numberOfSelections:uint;
		
		private var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		
		public function StochasticUniversalSamplingSelector(numberOfSelections:uint = 0)
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
			SelectionUtil.sortSpecimensByFitness(localSpecimens, Array.DESCENDING);
			
			var pointerSeparation:Number = 1.0 / numberOfSelections;
			var splitPoint:Number = randomNumberGenerator.float(pointerSeparation);
			var cumulativeProbability:Number = 0;
			var pointerIndex:int = 0; 
			for each (var specimen:ISpecimen in localSpecimens) {
				cumulativeProbability += specimen.normalizedFitness*numberOfSelections;
				while (pointerIndex + splitPoint < cumulativeProbability) {
					selectedSpecimens.push(specimen);
					pointerIndex++;
				}
			}
			// Catch corner case where, due to all fitness and accumualtedNormalizedFitness values being 0
			// no non-zero expected probabilities could be calculated, leading to no selections being made.
			// Fallback is to pick specimens from evenly spaced indices in the specimens array
			if (selectedSpecimens.length < numberOfSelections) {
				var fallbackPointerIndex:int = int(splitPoint*numberOfSelections)*localSpecimens.length; // Normalize original selection point to [0, specimens.length - 1]
				var fallbackSeparation:int = Math.max(1, localSpecimens.length / numberOfSelections);
				while (selectedSpecimens.length < numberOfSelections) {
					selectedSpecimens.push(localSpecimens[fallbackPointerIndex]);
					fallbackPointerIndex += fallbackSeparation;
					if (fallbackPointerIndex >= localSpecimens.length) {
						fallbackPointerIndex -= localSpecimens.length;
					}
				}
			}
			return selectedSpecimens;
		}
		
		public function get seed():uint {
			return randomNumberGenerator.seed;
		}
		
		public function set seed(value:uint):void {
			randomNumberGenerator.seed = value;
		}
	}
}