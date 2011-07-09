package galia.core
{
	public interface IPopulationEvolutionOperator
	{
		/**
		 * Produces a new population of specimens from a source Array of parent specimens.
		 * 
		 * @param specimens An Array of objects of type ISpecimen used in the creation of the new population
		 * @param targetPopulationSize The number of desired specimens produced by this function
		 * 
		 * @return An Array of objects of type ISpecimen representing a new unique population
		 */
		function evolvePopulation(specimens:Array, targetPopulationSize:uint):Array;
	}
}