package galia.core
{
	public interface IProcreationOperator
	{
		/**
		 * Produces new children chromosomes using parent chromosomes.
		 * 
		 * @param parentChromosomes An Array of objects of type IChromosome used in the creation of children 
		 * @return An array of objects of type IChromosome with at least the same length as the input parentChromosomes
		 */
		function procreate(parentChromosomes:Array):Array;
		
		/**
		 * Metadata helper function that indicates the minimum number of parent
		 * chromosomes necessary for the IProcreationOperator's implementation of
		 * the <code>procreate</code> method to function properly.`	
		 */
		function get numberOfParentsRequired():uint;
	}
}