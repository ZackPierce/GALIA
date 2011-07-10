package galia.core
{
	/** An interface for providing the chromosomes necessary for the initial population of an algorithm. */
	public interface ISeedingStrategy
	{
		/**
		 * @param numberOfChromosomes The number of IChromosome objects to be included in the output Array.
		 * @return An Array of objects of type IChromosome
		 */
		function generateChromosomes(numberOfChromosomes:uint):Array;
	}
}