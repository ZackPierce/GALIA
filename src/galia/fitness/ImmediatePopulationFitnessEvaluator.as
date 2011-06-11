package galia.fitness
{
	import galia.core.IAsynchronousSpecimenFitnessEvaluator;
	import galia.core.IPopulationFitnessEvaluator;
	import galia.core.ISpecimen;
	import galia.core.ISpecimenFitnessEvaluator;
	import galia.signals.PopulationFitnessEvaluated;
	
	/**
	 * This class implements IPopulationFitnessEvaluator in such a manner that a supplied helper
	 * ISpecimenFitnessEvaluator's evaluateSpecimenFitness function is called immediately for every specimen passed
	 * to evaluatePopulationFitness.
	 */
	public class ImmediatePopulationFitnessEvaluator implements IPopulationFitnessEvaluator
	{
		public var specimenFitnessEvaluator:ISpecimenFitnessEvaluator;
		
		private var _populationFitnessEvaluated:PopulationFitnessEvaluated = new PopulationFitnessEvaluated();
		private var unevaluatedSpecimens:Array;
		private var evaluatedSpecimens:Array;
		
		public function ImmediatePopulationFitnessEvaluator(specimenFitnessEvaluator:ISpecimenFitnessEvaluator = null) {
			this.specimenFitnessEvaluator = specimenFitnessEvaluator;
		}
		
		public function evaluatePopulationFitness(specimens:Array):void {
			if (!specimens || specimens.length == 0) {
				populationFitnessEvaluated.dispatch(specimens);
				return;
			}
			
			var usingAsynchronousSpecimenFitnessEvaluator:Boolean = specimenFitnessEvaluator is IAsynchronousSpecimenFitnessEvaluator;
			
			if (usingAsynchronousSpecimenFitnessEvaluator) {
				unevaluatedSpecimens = specimens.concat();
				evaluatedSpecimens = [];
				var asyncSpecimenFitnessEvaluator:IAsynchronousSpecimenFitnessEvaluator = specimenFitnessEvaluator as IAsynchronousSpecimenFitnessEvaluator;
				asyncSpecimenFitnessEvaluator.specimenFitnessEvaluated.add(specimenFitnessEvaluatedHandler);
			}
			
			for each (var specimen:ISpecimen in specimens) {
				specimenFitnessEvaluator.evaluateSpecimen(specimen);
			}
			
			if (!usingAsynchronousSpecimenFitnessEvaluator) {
				populationFitnessEvaluated.dispatch(specimens);
			}
		}
		
		private function specimenFitnessEvaluatedHandler(specimen:ISpecimen):void {
			var unevaluatedIndex:int = unevaluatedSpecimens.indexOf(specimen);
			unevaluatedSpecimens.splice(unevaluatedIndex, 1);
			evaluatedSpecimens.push(specimen);
			if (unevaluatedSpecimens.length == 0) {
				if (specimenFitnessEvaluator is IAsynchronousSpecimenFitnessEvaluator) {
					(specimenFitnessEvaluator as IAsynchronousSpecimenFitnessEvaluator).specimenFitnessEvaluated.remove(specimenFitnessEvaluatedHandler);
				}
				populationFitnessEvaluated.dispatch(evaluatedSpecimens);
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