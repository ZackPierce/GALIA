package galia.core
{
	public interface IAlgorithmLogger
	{
		function logAlgorithmStart():void;
		function logAlgorithmStop():void;
		
		/**
		 * Records a population's fitness data for later access.
		 * Typically called directly following the completion of fitness testing.
		 */
		function logPopulation(population:IPopulation):void;
		
		/**
		 * @return An Array of IPopulationSnapshot objects representing all IPopulations
		 * recorded so far with <code>logPopulation</code>.
		 */
		function getAllPopulationSnapshots():Array; // of IPopulationSnapshot
		
		/**
		 * @return The first IPopulationSnapshot logged with the given generation index value.
		 * Returns null if no such population has been logged.  If more than one population has
		 * been recorded with the same generationIndex, the most recently logged IPopulationSnapshot
		 * will be returned.  
		 */
		function getPopulationSnapshotForGeneration(generationIndex:uint):IPopulationSnapshot;
		
		/**
		 * @return The IPopulationSnapshot logged with the given unique populationIdentifer.
		 * Returns null if no such population has been logged.  If more than one population
		 * is found that shares the same populationIdentifier, the IPopulationSnapshot with
		 * the highest generationIndex most recently logged will be returned.
		 */
		function getPopulationSnapshotByPopulationIdentifier(populationIdentifier:String):IPopulationSnapshot;
		
		function getMaximumGenerationIndex():uint;
		
		/** The specimen in all logged populations with the highest fitness value */
		function getTopSpecimen():ISpecimen;
		
		/** The number of milliseconds during which the algorithm was running. 
		 * If the algorithm was stopped and started multiple times, the periods during
		 * which the algorithm was stopped do not add to the running duration.
		 */
		function getAlgorithmRunningDuration():uint // in milliseconds
		
		/**
		 * The time the algorithm was first started.
		 * This corresponds to the first time logAlgorithmStart was called.
		 */
		function getAlgorithmStartTime():Date;
		
		/**
		 * The time the algorithm was last stopped from running, or null if the algorithm is still running or was never started.
		 */
		function getAlgorithmStopTime():Date;
		
	}
}