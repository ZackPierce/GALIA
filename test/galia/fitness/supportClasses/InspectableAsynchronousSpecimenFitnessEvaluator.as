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
		public var specimensEvaluationStarted:Array = []
		public var specimensEvaluationCompleted:Array = [];
		
		protected static var frameSprite:Sprite = new Sprite();
		
		private var _specimenFitnessEvaluated:SpecimenFitnessEvaluated = new SpecimenFitnessEvaluated();
		
		public function InspectableAsynchronousSpecimenFitnessEvaluator()
		{
		}
		
		public function evaluateSpecimen(specimen:ISpecimen):void {
			specimensEvaluationStarted.push(specimen);
			frameSprite.addEventListener(Event.ENTER_FRAME, frameEnterHandler, false, 0, true);
		}
		
		private function frameEnterHandler(event:Event):void {
			frameSprite.removeEventListener(Event.ENTER_FRAME, frameEnterHandler, false);
			for each (var specimen:ISpecimen in specimensEvaluationStarted) {
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