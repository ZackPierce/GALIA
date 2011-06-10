package galia.core
{
	import galia.signals.PopulationFitnessEvaluated;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public interface IPopulationFitnessEvaluator
	{
		/**
		 * Begins the evaluation of the fitness values of the input specimens.
		 * The populationFitnessEvaluated signal is expected to dispatch the
		 * evaluated Array of ISpecimens once the fitness property is set for
		 * every member.
		 * 
		 * @param specimens An Array of objects of type ISpecimen
		 */
		function evaluatePopulationFitness(specimens:Array):void;
		
		/**
		 * Signal used to announce the completion of the determination of the fitness
		 * values of all specimens fed to the evaluatePopulationFitness function.
		 */
		function get populationFitnessEvaluated():PopulationFitnessEvaluated;
		function set populationFitnessEvaluated(populationFitnessEvaluatedSignal:PopulationFitnessEvaluated):void;
	}
}