package galia.base
{
	import galia.core.IPopulationSnapshot;
	import galia.core.ISpecimen;
	
	public class PopulationSnapshot implements IPopulationSnapshot
	{
		private var _generationIndex:uint;
		private var _maxFitness:Number;
		private var _meanFitness:Number;
		private var _medianFitness:Number;
		private var _minFitness:Number;
		private var _populationIdentifier:String;
		private var _numberOfSpecimens:uint;
		private var _standardDeviationFitness:Number;
		private var _topSpecimen:ISpecimen;
		
		public function PopulationSnapshot(generationIndex:uint, maxFitness:Number, meanFitness:Number, medianFitness:Number, minFitness:Number, numberOfSpecimens:uint, populationIdentifier:String, standardDeviationFitness:Number, topSpecimen:ISpecimen) {
			this._generationIndex = generationIndex;
			this._maxFitness = maxFitness;
			this._meanFitness = meanFitness;
			this._medianFitness = medianFitness;
			this._minFitness = minFitness;
			this._numberOfSpecimens = numberOfSpecimens;
			this._populationIdentifier = populationIdentifier;
			this._standardDeviationFitness = standardDeviationFitness;
			this._topSpecimen = topSpecimen;
		}
		
		public function get generationIndex():uint {
			return _generationIndex;
		}
		
		public function get maxFitness():Number {
			return _maxFitness;
		}
		
		public function get meanFitness():Number {
			return _meanFitness;
		}
		
		public function get medianFitness():Number {
			return _medianFitness;
		}
		
		public function get minFitness():Number {
			return _minFitness;
		}
		
		public function get numberOfSpecimens():uint {
			return _numberOfSpecimens;
		}
		
		public function get populationIdentifier():String {
			return _populationIdentifier;
		} 
		
		public function get standardDeviationFitness():Number {
			return _standardDeviationFitness;
		}
		
		public function get topSpecimen():ISpecimen {
			return _topSpecimen;
		}
		
		/** Creates an populates a PopulationSnapshot with the nececessary statistical data. */
		public static function generatePopulationSnapshot(generationIndex:uint, populationIdentifier:String, specimens:Array):PopulationSnapshot {
			var maxFitness:Number = Number.MIN_VALUE;
			var minFitness:Number = Number.MAX_VALUE;
			var meanFitness:Number = 0;
			var medianFitness:Number = 0;
			var numSpecimens:uint = 0;
			var localSpecimens:Array;
			var standardDeviationFitness:Number = 0;
			var topSpecimen:ISpecimen = null;
			if (specimens && specimens.length > 0) {
				numSpecimens = specimens.length;
				localSpecimens = specimens.slice();
			} else {
				new PopulationSnapshot(generationIndex, maxFitness, meanFitness, medianFitness, minFitness, numSpecimens, populationIdentifier, standardDeviationFitness, topSpecimen);
			}
			localSpecimens.sortOn('fitness', Array.NUMERIC);
			minFitness = localSpecimens[0].fitness;
			topSpecimen = localSpecimens[numSpecimens - 1];
			maxFitness = topSpecimen.fitness;
			var midPoint:uint = numSpecimens / 2;
			if (numSpecimens % 2 != 0) {
				medianFitness = localSpecimens[midPoint].fitness;
			} else {
				medianFitness = localSpecimens[midPoint - 1].fitness + (localSpecimens[midPoint].fitness - localSpecimens[midPoint - 1].fitness) / 2;
			}
			
			var ss:Number = 0;
			var sum:Number = 0;
			for each (var specimen:ISpecimen in localSpecimens) {
				var fitness:Number = specimen.fitness;
				sum += fitness;
				ss += fitness*fitness;
			}
			meanFitness = sum/numSpecimens;
			standardDeviationFitness = Math.sqrt(ss/numSpecimens - meanFitness*meanFitness);
			
			return new PopulationSnapshot(generationIndex, maxFitness, meanFitness, medianFitness, minFitness, numSpecimens, populationIdentifier, standardDeviationFitness, topSpecimen);
		}
	}
}