package galia.core
{
	/**
	 * An immutable value object containing statistics about a given population.
	 */
	public interface IPopulationSnapshot
	{
		/** The generational position of the population relative to the start of the algorithm. */ 
		function get generationIndex():uint;
		
		/** The maximum fitness value of all specimens in the population. */
		function get maxFitness():Number;
		
		/** The mean fitness value of all specimens in the population. */
		function get meanFitness():Number;
		
		/** The median fitness value of all specimens in the population. */
		function get medianFitness():Number;
		
		/** The minimum fitness value of all specimens in the population/ */
		function get minFitness():Number;
		
		/** A unique identifier for the population.
		 * Distinct from the generationIndex if the algorithm uses multiple populations
		 * per "generation".
		 */
		function get populationIdentifier():String;
		
		/** The number of specimens in the population. */
		function get numberOfSpecimens():uint;
		
		/** The standard deviation of the fitness values of all specimens in the population. */
		function get standardDeviationFitness():Number;
		
		/** The specimen with the highest fitness value in the population. */
		function get topSpecimen():ISpecimen;
	}
}