package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.IPopulation;
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	
	public class RouletteWheelSelector extends BaseSelector implements ISelector
	{
		public function RouletteWheelSelector(numberOfSelections:Number = 0) {
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
	}
}