package galia.core
{
	public interface IProcreationOperator
	{
		/**
		 * Produces new children chromosomes using parent chromosomes
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