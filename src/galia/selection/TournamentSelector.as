package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.IPopulation;
	import galia.core.ISelector;
	
	public class TournamentSelector implements ISelector
	{
		public var tournamentSize:uint = 2;
		
		private var _numberOfSelections:uint;
		private var _bestSelectionProbability:Number = 1.0; 
		
		private var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		
		public function TournamentSelector(numberOfSelections:uint = 0, tournamentSize:uint = 2, bestSelectionProbability:Number = 1.0)
		{
			this.numberOfSelections = numberOfSelections;
			this.tournamentSize = tournamentSize;
			this.bestSelectionProbability = bestSelectionProbability;
		}
		
		/** 
		 * A Number between 0 and 1 indicating the probability that the ISpecimen with the highest fitness
		 * will be chosen in any given tournament executed during the selection process
		 */
		public function get bestSelectionProbability():Number {
			return this._bestSelectionProbability;
		}
		
		/** 
		 * A Number between 0 and 1 indicating the probability that the ISpecimen with the highest fitness
		 * will be chosen in any given tournament executed during the selection process
		 */
		public function set bestSelectionProbability(value:Number):void {
			this._bestSelectionProbability = Math.max(0, Math.min(1.0, value));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numberOfSelections():uint {
			return _numberOfSelections;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set numberOfSelections(value:uint):void {
			this._numberOfSelections = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectSurvivors(specimens:Array):Array {
			if (!specimens || specimens.length == 0 || numberOfSelections == 0 || tournamentSize == 0) {
				return [];
			}
			
			var localSpecimens:Array = specimens.concat();
			var selectedSpecimens:Array = [];
			var availableSpecimensLength:uint = localSpecimens.length;
			var p:Number = bestSelectionProbability;
			var oneMinusP:Number = 1.0 - bestSelectionProbability;
			
			var cumulativeProbabilitiesList:Array = [];
			var cumulativeProbability:Number = 0;
			for (var i:int = 0; i < tournamentSize; i++) {
				var probability:Number = p*Math.pow(oneMinusP, i);
				cumulativeProbability += probability;
				cumulativeProbabilitiesList.push(cumulativeProbability);
			}
			
			while (selectedSpecimens.length < numberOfSelections) {
				var tournamentParticipants:Array = [];
				for (var k:int = 0; k < tournamentSize; k++) {
					tournamentParticipants.push(localSpecimens[randomNumberGenerator.integer(0, availableSpecimensLength)]);
				}
				SelectionUtil.sortSpecimensByFitness(tournamentParticipants, Array.NUMERIC | Array.DESCENDING);
				var splitPoint:Number = randomNumberGenerator.random();
				for (var m:int = 0; m < tournamentSize; m++) {
					if (splitPoint <= cumulativeProbabilitiesList[m] || m == tournamentSize - 1) {
						selectedSpecimens.push(tournamentParticipants[m]);
						break;
					}
				}
			}
			
			return selectedSpecimens;
		}
		
		public function get seed():uint {
			return randomNumberGenerator.seed;
		}
		
		public function set seed(value:uint):void {
			randomNumberGenerator.seed = value;
		} 
	}
}