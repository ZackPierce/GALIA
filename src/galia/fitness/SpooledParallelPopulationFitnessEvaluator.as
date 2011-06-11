package galia.fitness
{
	import galia.core.IAsynchronousSpecimenFitnessEvaluator;
	import galia.core.IPopulationFitnessEvaluator;
	import galia.core.ISpecimen;
	import galia.signals.PopulationFitnessEvaluated;
	
	public class SpooledParallelPopulationFitnessEvaluator implements IPopulationFitnessEvaluator
	{
		public var asynchronousSpecimenFitnessEvaluator:IAsynchronousSpecimenFitnessEvaluator;
		public var maximumParallelActiveSpecimenFitnessEvaluations:uint = 1;
		
		private var _populationFitnessEvaluated:PopulationFitnessEvaluated = new PopulationFitnessEvaluated();
		
		private var specimensEvaluationPending:Array;
		private var specimensEvaluationActive:Array;
		private var specimensEvaluationComplete:Array;
		
		public function SpooledParallelPopulationFitnessEvaluator(maximumParallelActiveSpecimenFitnessEvaluations:uint = 1, asynchronousSpecimenFitnessEvaluator:IAsynchronousSpecimenFitnessEvaluator = null) {
			this.maximumParallelActiveSpecimenFitnessEvaluations = maximumParallelActiveSpecimenFitnessEvaluations;
			this.asynchronousSpecimenFitnessEvaluator = asynchronousSpecimenFitnessEvaluator;
		}
		
		public function evaluatePopulationFitness(specimens:Array):void {
			if (!specimens || specimens.length == 0) {
				populationFitnessEvaluated.dispatch(specimens);
				return;
			}
			specimensEvaluationPending = specimens.concat();
			specimensEvaluationActive = [];
			specimensEvaluationComplete = [];
			asynchronousSpecimenFitnessEvaluator.specimenFitnessEvaluated.add(specimenFitnessEvaluatedHandler);
			beginNextSpecimenEvaluations();
		}
		
		private function beginNextSpecimenEvaluations():void {
			while (specimensEvaluationPending.length > 0 && specimensEvaluationActive.length < maximumParallelActiveSpecimenFitnessEvaluations) {
				var specimen:ISpecimen = specimensEvaluationPending.shift();
				specimensEvaluationActive.push(specimen);
				asynchronousSpecimenFitnessEvaluator.evaluateSpecimen(specimen);
			}
		}
		
		private function specimenFitnessEvaluatedHandler(specimen:ISpecimen):void {
			var activeIndex:int = specimensEvaluationActive.indexOf(specimen);
			specimensEvaluationActive.splice(activeIndex, 1);
			specimensEvaluationComplete.push(specimen);
			beginNextSpecimenEvaluations();
			if (specimensEvaluationPending.length == 0 && specimensEvaluationActive.length == 0) {
				asynchronousSpecimenFitnessEvaluator.specimenFitnessEvaluated.remove(specimenFitnessEvaluatedHandler);
				populationFitnessEvaluated.dispatch(specimensEvaluationComplete);
			}
		}
		
		public function get populationFitnessEvaluated():PopulationFitnessEvaluated {
			return _populationFitnessEvaluated;
		}
		
		public function set populationFitnessEvaluated(populationFitnessEvaluatedSignal:PopulationFitnessEvaluated):void {
			_populationFitnessEvaluated = populationFitnessEvaluatedSignal;
		}
	}
}