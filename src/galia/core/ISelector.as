package galia.core
{
	public interface ISelector
	{
		/**
		 * Expected to return an array containing certain members of an IPopulation's specimens property
		 * that have been selected for "survival." Survival implies their usage in the creation of the
		 * next generation's population.
		 * 
		 * @return An array of objects of type ISpecimen
		 */
		function selectSurvivors(population:IPopulation):Array;
	}
}