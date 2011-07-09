package galia.selection
{
	import galia.core.ISpecimen;

	public class SelectionUtil
	{
		public function SelectionUtil() {
		}
		
		/**
		 * Sorts an array of objects of type ISpecimen by their fitness property, in ascending order by default.
		 * 
		 * @param specimens The array of ISpecimen objects to sort
		 * @param sortOptions See the Array.sort function's sortOptions parameter
		 */
		public static function sortSpecimensByFitness(specimens:Array, sortOptions:uint = Array.NUMERIC):void {
			if (!specimens) {
				return;
			}
			specimens.sortOn('fitness', Array.NUMERIC | sortOptions);
		}
		
		/**
		 * Calculates and set the values for the normalizedFitness and accumulatedNormalizedFitness properties 
		 * for an input array of ISpecimen objects using their raw fitness properties.
		 * 
		 * Assumes that the ISpecimens have already had a fitness test run on them to determine their raw fitness values,
		 * and that all fitness values are greater than or equal to 0 and less than or equal to Number.MAX_VALUE - 1.
		 * 
		 * The sum of all fitness values of the specimens should not equal 0 or exceed Number.MAX_VALUE, lest the normalization process be ruined.
		 * 
		 * This function will sort the specimens array ascending by fitness.
		 *  
		 * @param specimens An array of objects of type ISpecimen that already have their fitness property set.
		 * @param rawFitnessSum The optional pre-calculated sum of all of the fitness property values of the input specimens array 
		 */
		public static function calculateNormalizedAndAccumulatedNormalizedFitnessesValues(specimens:Array, rawFitnessSum:Number = 0):void {
			if (!specimens || specimens.length == 0) {
				return;
			}
			var localRawFitnessSum:Number = rawFitnessSum;
			if (localRawFitnessSum == 0) {
				for each (var specimen:ISpecimen in specimens) {
					localRawFitnessSum += specimen.fitness;
				}
			}
			
			sortSpecimensByFitness(specimens);
			
			var accumulatedNormalizedFitness:Number = 0;
			var useUniformNormalizedFitness:Boolean = localRawFitnessSum == 0; // If all fitness values were zero, use a fallback normalizedFitness value
			var uniformNormalizedFitness:Number = 1.0 / specimens.length;
			for each (var specimenAgain:ISpecimen in specimens) {
				specimenAgain.normalizedFitness = useUniformNormalizedFitness ? uniformNormalizedFitness : specimenAgain.fitness / localRawFitnessSum;
				accumulatedNormalizedFitness += specimenAgain.normalizedFitness;
				specimenAgain.accumulatedNormalizedFitness = accumulatedNormalizedFitness;
			}
		}
	}
}