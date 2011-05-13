package galia.core
{
	public interface ISelector
	{
		/**
		 * Expected to return an array of members of the input specimens array
		 * that have been selected for "survival." Survival implies their usage in the creation of the
		 * next generation's population.
		 * 
		 * @param specimens An Array of objects of type ISpecimen representing the members of a population
		 * @return An array of objects of type ISpecimen
		 */
		function selectSurvivors(specimens:Array):Array;
		
		/**
		 * @return The number of specimens expected to be selected by each selectSurvivors call
		 */
		function get numberOfSelections():uint;
		
		/**
		 * @param The number of specimens expected to be selected by each selectSurvivors call.
		 */
		function set numberOfSelections(value:uint):void;
	}
}