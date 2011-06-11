package galia.fitness.supportClasses
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import galia.core.IAsynchronousSpecimenFitnessEvaluator;
	import galia.core.ISpecimen;
	import galia.core.ISpecimenFitnessEvaluator;
	import galia.signals.SpecimenFitnessEvaluated;
	
	public class InspectableAsynchronousSpecimenFitnessEvaluator implements IAsynchronousSpecimenFitnessEvaluator
	{
		public var specimensEvaluationActive:Array = []
		public var specimensEvaluationCompleted:Array = [];
		
		protected static var frameSprite:Sprite = new Sprite();
		
		private var _specimenFitnessEvaluated:SpecimenFitnessEvaluated = new SpecimenFitnessEvaluated();
		
		public function InspectableAsynchronousSpecimenFitnessEvaluator()
		{
		}
		
		public function evaluateSpecimen(specimen:ISpecimen):void {
			specimensEvaluationActive.push(specimen);
			frameSprite.addEventListener(Event.ENTER_FRAME, frameEnterHandler, false, 0, true);
		}
		
		private function frameEnterHandler(event:Event):void {
			frameSprite.removeEventListener(Event.ENTER_FRAME, frameEnterHandler, false);
			for (var i:int = specimensEvaluationActive.length - 1; i >= 0; i--) {
				var specimen:ISpecimen = specimensEvaluationActive[i];
				specimensEvaluationActive.splice(specimensEvaluationActive.indexOf(specimen), 1);
				var index:int = specimensEvaluationCompleted.indexOf(specimen);
				if (index == -1) {
					specimen.fitness = 1;
					specimen.isFitnessTested = true;
					specimensEvaluationCompleted.push(specimen);
					specimenFitnessEvaluated.dispatch(specimen);
				}
			}
		}
		
		public function get specimenFitnessEvaluated():SpecimenFitnessEvaluated {
			return this._specimenFitnessEvaluated;
		}
		
		public function set specimenFitnessEvaluated(specimenFitnessEvaluatedSignal:SpecimenFitnessEvaluated):void {
			this._specimenFitnessEvaluated = specimenFitnessEvaluatedSignal;
		}
	}
}