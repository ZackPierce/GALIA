package galia.signals
{
	import org.osflash.signals.Signal;
	
	/**
	 * Signal that dispatches an Array of objects of type ISpecimen whose fitness values have been set
	 */
	public class PopulationFitnessEvaluated extends Signal
	{
		public function PopulationFitnessEvaluated()
		{
			super(Array);
		}
	}
}