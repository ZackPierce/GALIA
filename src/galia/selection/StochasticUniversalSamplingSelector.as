package galia.selection
{
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	
	public class StochasticUniversalSamplingSelector extends BaseSelector implements ISelector
	{
		public function StochasticUniversalSamplingSelector(numberOfSelections:uint = 0) {
			super(numberOfSelections);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function selectSurvivors(specimens:Array):Array {
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
	}
}