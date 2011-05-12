package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.IPopulation;
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	
	public class StochasticUniversalSamplingSelector implements ISelector
	{
		private var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		public var numberOfSelections:uint;
		
		public function StochasticUniversalSamplingSelector(numberOfSelections:uint = 0)
		{
			this.numberOfSelections = numberOfSelections;
		}
		
		public function selectSurvivors(population:IPopulation):Array {
			if (!population) {
				return [];
			}
			
			var specimens:Array = population.specimens;
			if (!specimens || specimens.length == 0 || numberOfSelections == 0) {
				return [];
			} else {
				specimens = specimens.concat();
			}
			
			var selectedSpecimens:Array = [];
			
			
			SelectionUtil.calculateNormalizedAndAccumulatedNormalizedFitnessesValues(specimens);
			SelectionUtil.sortSpecimensByFitness(specimens, Array.DESCENDING);
			var pointerSeparation:Number = 1.0 / numberOfSelections;
			var splitPoint:Number = randomNumberGenerator.float(pointerSeparation);
			var cumulativeProbability:Number = 0;
			var pointerIndex:int = 0; 
			for each (var specimen:ISpecimen in specimens) {
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
				var fallbackPointerIndex:int = int(splitPoint*numberOfSelections)*specimens.length; // Normalize original selection point to [0, specimens.length - 1]
				var fallbackSeparation:int = Math.max(1, specimens.length / numberOfSelections);
				while (selectedSpecimens.length < numberOfSelections) {
					selectedSpecimens.push(specimens[fallbackPointerIndex]);
					fallbackPointerIndex += fallbackSeparation;
					if (fallbackPointerIndex >= specimens.length) {
						fallbackPointerIndex -= specimens.length;
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