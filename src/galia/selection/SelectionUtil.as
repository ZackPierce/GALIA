package galia.selection
{
	import galia.core.ISpecimen;

	public class SelectionUtil
	{
		public function SelectionUtil()
		{
		}
		
		/**
		 * Sorts an array of objects of type ISpecimen by their fitness property, in ascending order.
		 */
		public static function sortSpecimensByFitness(specimens:Array):void {
			if (!specimens) {
				return;
			}
			specimens.sort(compareFitnesses);
		}
		
		private static function compareFitnesses(specimenA:Object, specimenB:Object):int  {
			return specimenA.fitness - specimenB.fitness;
		}
		
		/**
		 * Calculates and set the values for the standardizedFitness, adjustedFitness, normalizedFitness, and accumulatedNormalizedFitness
		 * for an input array of ISpecimen objects using their raw fitness properties.
		 * 
		 * Assumes that the ISpecimens have already had a fitness test run on them to determine their raw fitness values,
		 * and that all fitness values are greater than or equal to 0 and less than or equal to Number.MAX_VALUE - 1.
		 *  
		 * @param specimens An array of objects of type ISpecimen that already have their fitness property set. 
		 */
		public static function calculateAllDerivedFitnessValues(specimens:Array):void {
			if (!specimens) {
				return;
			}
			var adjustedFitnessSum:Number = calculateStandardizedAndAdjustedFitnessesFromRawFitnesses(specimens)
			calculateNormalizedAndAccumulatedNormalizedFitnessesFromAdjustedFitnesses(specimens, adjustedFitnessSum);
		}
		
		/**
		 * Calculates and set the values for the standardizedFitness and adjustedFitness proprties
		 * for an input array of ISpecimen objects using their raw fitness properties.
		 * 
		 * Assumes that the ISpecimens have already had a fitness test run on them to determine their raw fitness values,
		 * and that all fitness values are greater than or equal to 0 and less than or equal to Number.MAX_VALUE - 1.
		 *  
		 * @param specimens An array of objects of type ISpecimen that already have their fitness property set.
		 * @return The sum of all adjustedFitness values
		 */
		public static function calculateStandardizedAndAdjustedFitnessesFromRawFitnesses(specimens:Array):Number {
			if (!specimens) {
				return 0;
			}
			var adjustedFitnessSum:Number = 0;
			for each (var specimen:ISpecimen in specimens) {
				specimen.standardizedFitness = Number.MAX_VALUE - 1 - specimen.fitness;
				specimen.adjustedFitness = 1.0 / (1 + specimen.standardizedFitness);
				adjustedFitnessSum += specimen.adjustedFitness;
			}
			return adjustedFitnessSum;
		}
		
		/**
		 * Calculates and set the values for the normalizedFitness and accumulatedNormalizedFitness properties
		 * for an input array of ISpecimen objects using their adjustedFitness properties.
		 * 
		 * Assumes that the ISpecimens have already had a fitness test run on them to determine their raw fitness values,
		 * that all fitness values are greater than or equal to 0 and less than or equal to Number.MAX_VALUE - 1, 
		 * and that the ISpecimen.adjustedFitness properties have been set.
		 *  
		 * @param specimens An array of objects of type ISpecimen that already have their adjustedFitness property set.
		 * @param adjustedFitnessSum The optional pre-calculated sum of all of the adjustedFitness property values of the input specimens array
		 */
		public static function calculateNormalizedAndAccumulatedNormalizedFitnessesFromAdjustedFitnesses(specimens:Array, adjustedFitnessSum:Number = 0):void {
			if (!specimens) {
				return;
			}
			
			var localAdjustedFitnessSum:Number = adjustedFitnessSum;
			if (localAdjustedFitnessSum == 0) {
				for each (var specimen:ISpecimen in specimens) {
					localAdjustedFitnessSum += specimen.adjustedFitness;
				}
				if (localAdjustedFitnessSum == 0) {
					return;
				}
			}
			
			var accumulatedNormalizedFitness:Number = 0;
			for each (var specimenAgain:ISpecimen in specimens) {
				specimenAgain.normalizedFitness = specimenAgain.adjustedFitness / localAdjustedFitnessSum;
				accumulatedNormalizedFitness += specimenAgain.normalizedFitness;
				specimenAgain.accumulatedNormalizedFitness = accumulatedNormalizedFitness;
			}
		}
	}
}