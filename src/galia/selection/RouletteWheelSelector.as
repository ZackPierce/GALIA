package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.IPopulation;
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	
	public class RouletteWheelSelector implements ISelector
	{
		public var numberOfSelections:uint;
		
		private var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		
		public function RouletteWheelSelector(numberOfSelections:Number = 0)
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
			while (selectedSpecimens.length < numberOfSelections) {
				var spinPoint:Number = randomNumberGenerator.random();
				// TODO - implement more efficient binary search
				for each (var specimen:ISpecimen in specimens) {
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