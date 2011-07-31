package galia.signals
{
	import galia.core.IPopulation;
	import galia.core.IPopulationSnapshot;
	
	import org.osflash.signals.Signal;

	public class PopulationFinished extends Signal
	{
		public function PopulationFinished() {
			super(IPopulation, IPopulationSnapshot);
		}
	}
}