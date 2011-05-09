package galia.base
{
	import galia.core.IChromosome;
	import galia.core.ISpecimen;

	public class Specimen implements ISpecimen
	{
		private var _id:String;
		private var _chromosome:IChromosome;
		
		private var _fitness:Number = 0;
		private var _normalizedFitness:Number = 0;
		private var _accumulatedNormalizedFitness:Number = 0;
		private var _isFitnessTested:Boolean = false;
		
		public function Specimen()
		{
		}
		
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		public function get chromosome():IChromosome {
			return _chromosome;
		}
		
		public function set chromosome(value:IChromosome):void {
			_chromosome = value;
		}
		
		public function get fitness():Number {
			return _fitness;
		}
		
		public function set fitness(value:Number):void {
			_fitness = value;
		}
				
		public function get normalizedFitness():Number {
			return _normalizedFitness;
		}
		
		public function set normalizedFitness(value:Number):void {
			_normalizedFitness = value;
		}
		
		public function get isFitnessTested():Boolean {
			return _isFitnessTested;
		}
		
		public function set isFitnessTested(value:Boolean):void {
			_isFitnessTested = value;
		}
		
		public function get accumulatedNormalizedFitness():Number {
			return _accumulatedNormalizedFitness;
		}
		
		public function set accumulatedNormalizedFitness(value:Number):void {
			_accumulatedNormalizedFitness = value;
		}
	}
}