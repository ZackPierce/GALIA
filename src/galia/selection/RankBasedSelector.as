package galia.selection
{
	import flash.utils.Dictionary;
	
	import galia.core.ISelector;
	import galia.core.ISpecimen;
	
	public class RankBasedSelector extends BaseSelector implements ISelector
	{
		private var _helperSelector:ISelector;
		
		public function RankBasedSelector(numberOfSelections:uint = 0, helperSelector:ISelector = null) {
			super(numberOfSelections);
			if (helperSelector) {
				this._helperSelector = helperSelector;
			} else {
				this._helperSelector = generateDefaultHelperSelector();
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function selectSurvivors(specimens:Array):Array {
			if (!specimens || specimens.length == 0 || numberOfSelections == 0) {
				return [];
			}
			
			var localSpecimens:Array = specimens.concat();
			
			// Catch null or pointlessly recursive helperSelectors
			if (!helperSelector || helperSelector is RankBasedSelector && (helperSelector as RankBasedSelector).helperSelector is RankBasedSelector) {
				helperSelector = generateDefaultHelperSelector();
			}
			helperSelector.numberOfSelections = numberOfSelections;
			SelectionUtil.sortSpecimensByFitness(localSpecimens, Array.DESCENDING);
			var originalFitnessesBySpecimen:Dictionary = new Dictionary();
			var populationSize:uint = localSpecimens.length;
			for (var i:int;  i < populationSize; i++) {
				var specimen:ISpecimen = localSpecimens[i];
				originalFitnessesBySpecimen[specimen] = specimen.fitness;
				specimen.fitness = rankToFitnessCalculation(i, populationSize);
			}
			
			// Delegate selection based on the new relative rank-fitness values to an ISelector
			// that operates on absolute ISpecimen.fitness values
			var selectedSpecimens:Array = helperSelector.selectSurvivors(localSpecimens);
			if (!selectedSpecimens) {
				return [];
			}
			
			// Attempt to re-apply the original non-rank-based absolute fitness values
			// Assumes that the selected ISpecimen objects are members of the original
			// localSpecimens set, and NOT copies or clones of some sort.
			for (var j:int;  j < selectedSpecimens.length; j++) {
				var selectedSpecimen:ISpecimen = selectedSpecimens[j];
				var originalFitness:Number = originalFitnessesBySpecimen[selectedSpecimen];
				if (!isNaN(originalFitness)) {
					selectedSpecimen.fitness = originalFitness;
				}
			}
			
			return selectedSpecimens;
		}
		
		/**
		 * Helper function that converts a specimen's rank to a fitness value.  Linear by default.
		 * Assumes that rankIndex is 0-index, and that a lower rankIndex indicates the highest original fitness
		 * in the population.
		 * 
		 * @param rankIndex The index of the specimen being assigned a fitness, assuming that 0 is the rankIndex of the specimen with the highest fitness in the population
		 * @param populationSize The total number of individual specimens being considered for selection in the selectSurvivors operation
		 */
		public function rankToFitnessCalculation(rankIndex:uint, populationSize:uint):Number {
			return populationSize - rankIndex;
		} 
		
		/**
		 * @return An ISelector instance used to select ISpecimens based on the secondary fitness values calculated by the RankBasedSelector
		 */
		public function get helperSelector():ISelector {
			return _helperSelector;
		}
		
		/**
		 * @param value An ISelector instance used to select ISpecimens based on the secondary fitness values calculated by the RankBasedSelector
		 */
		public function set helperSelector(value:ISelector):void {
			_helperSelector = value;
		}
		
		protected function generateDefaultHelperSelector():ISelector {
			return new StochasticUniversalSamplingSelector(this.numberOfSelections);
		} 
	}
}