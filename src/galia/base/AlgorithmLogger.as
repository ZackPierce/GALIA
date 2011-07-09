package galia.base
{
	import flash.utils.Dictionary;
	
	import galia.core.IAlgorithmLogger;
	import galia.core.IPopulation;
	import galia.core.IPopulationSnapshot;
	import galia.core.ISpecimen;
	
	public class AlgorithmLogger implements IAlgorithmLogger
	{
		private var _maximumGenerationIndex:uint;
		private var _topSpecimen:ISpecimen;
		
		private var snapshotArraysByGenerationIndex:Dictionary; // dict[uint] = Array of type IPopulationSnapshot
		private var allGenerationIndices:Array; // of type uint
		private var startStopDatePairs:Array; // of type DatePair
		
		public function AlgorithmLogger(logStartImmediately:Boolean = false) {
			snapshotArraysByGenerationIndex = new Dictionary(false);
			allGenerationIndices = [];
			startStopDatePairs = [];
			if (logStartImmediately) {
				logAlgorithmStart();
			}
		}
		
		public function logPopulation(population:IPopulation):void {
			if (!population) {
				return;
			}
			var generationIndex:uint = population.generationIndex;
			var snapshot:IPopulationSnapshot = PopulationSnapshot.generatePopulationSnapshot(generationIndex, population.id, population.specimens);
			if (allGenerationIndices.indexOf(generationIndex) >= 0) {
				snapshotArraysByGenerationIndex[generationIndex].push(snapshot);
			} else {
				allGenerationIndices.push(generationIndex);
				allGenerationIndices.sort(Array.NUMERIC);
				_maximumGenerationIndex = allGenerationIndices[allGenerationIndices.length - 1];
				snapshotArraysByGenerationIndex[generationIndex] = [snapshot];
			}
			
			if (!_topSpecimen || snapshot.topSpecimen && snapshot.topSpecimen.fitness > _topSpecimen.fitness) {
				_topSpecimen = snapshot.topSpecimen;
			} 
		}
		
		public function getAllPopulationSnapshots():Array {
			var snapshots:Array = [];
			for each (var index:uint in allGenerationIndices) {
				snapshots = snapshots.concat(snapshotArraysByGenerationIndex[index]);
			}
			return snapshots;
		}
		
		public function getPopulationSnapshotForGeneration(generationIndex:uint):IPopulationSnapshot {
			if (allGenerationIndices.indexOf(generationIndex) >= 0) {
				var snapshots:Array = snapshotArraysByGenerationIndex[generationIndex];
				return snapshots[snapshots.length - 1];
			} else {
				return null;
			}
		}
		
		public function getPopulationSnapshotByPopulationIdentifier(populationIdentifier:String):IPopulationSnapshot {
			// Assume that allGenerationIndices is already sorted in ascending order
			for (var i:int = allGenerationIndices.length - 1; i >= 0; i--) {
				var generationIndex:uint = allGenerationIndices[i];
				var snapshotCollection:Array = snapshotArraysByGenerationIndex[generationIndex];
				// Assume that snapshot collection is ordered such that the most recently logged snapshots are at the end of the array
				for (var j:int = snapshotCollection.length - 1; j >= 0; j--) {
					if (snapshotCollection[j].populationIdentifier == populationIdentifier) {
						return snapshotCollection[j];
					}
				}
			}
			return null;
		}
		
		public function getMaximumGenerationIndex():uint {
			return _maximumGenerationIndex;
		}
		
		public function getTopSpecimen():ISpecimen {
			return _topSpecimen;
		}
		
		public function logAlgorithmStart():void {
			if (startStopDatePairs.length == 0 || startStopDatePairs[startStopDatePairs.length - 1].stop != null) {
				startStopDatePairs.push(new DatePair());
			}
		}
		
		public function logAlgorithmStop():void {
			var pairLength:uint = startStopDatePairs.length;
			if (pairLength > 0) {
				var lastPair:DatePair = startStopDatePairs[pairLength - 1];
				if (!lastPair.stop) {
					lastPair.stop = new Date();
				}
			}
		}
		
		public function getAlgorithmRunningDuration():uint {
			var duration:uint = 0;
			for each (var datePair:DatePair in startStopDatePairs) {
				duration += (datePair.stop ? datePair.stop.time : new Date().time) - datePair.start.time;
			}
			return duration;
		}
		
		public function getAlgorithmStartTime():Date {
			return startStopDatePairs.length > 0 ? startStopDatePairs[0].start : null;
		}
		
		public function getAlgorithmStopTime():Date {
			return startStopDatePairs.length > 0 ? startStopDatePairs[startStopDatePairs.length - 1].stop : null;
		}
	}
}

class DatePair {
	public var start:Date = new Date();
	public var stop:Date;
}