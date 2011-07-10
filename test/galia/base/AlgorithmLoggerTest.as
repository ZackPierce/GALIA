package galia.base
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flexunit.framework.Assert;
	
	import galia.core.IAlgorithmLogger;
	import galia.core.IPopulation;
	import galia.core.IPopulationSnapshot;
	import galia.core.ISpecimen;
	
	import org.flexunit.async.Async;
	
	public class AlgorithmLoggerTest
	{
		private var algorithmLogger:AlgorithmLogger;
		private var populationAlpha:IPopulation;
		private var populationBeta:IPopulation;
		private var asyncTimer:Timer;
		private var timeA:Number;
		private var timeB:Number;
		
		private const TIME_IMPRECISION_TOLERANCE:uint = 35;  
		
		[Before]
		public function setUp():void {
			algorithmLogger = new AlgorithmLogger();
			populationAlpha = new Population(0, 'alpha');
			populationBeta = new Population(1, 'beta');
			asyncTimer = new Timer(180, 1);
		}
		
		[After]
		public function tearDown():void {
			algorithmLogger = null;
			populationAlpha = null;
			populationBeta = null;
			asyncTimerCleanup();
			timeA = 0;
			timeB = 0;
		}
		
		private function asyncTimerCleanup():void {
			if (asyncTimer) {
				asyncTimer.stop();
			}
			asyncTimer = null;
		}
		
		private function valueWithinTolerance(value:Number, target:Number, allowedError:Number):Boolean {
			if (value > target - allowedError && value < target + allowedError) {
				return true;
			} else {
				trace('failed tolerance test -- value: ' + value + ' target: ' + target + ' allowedError: ' + allowedError);
				return false;
			}
		}
		
		[Test]
		public function testGetAllPopulationSnapshots():void {
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			var foundSnapshots:Array = algorithmLogger.getAllPopulationSnapshots();
			Assert.assertNotNull("returned snapshots array should be non-null");
			Assert.assertStrictlyEquals("returned snapshots collection should have the same length as the number of populations logged", 2, foundSnapshots.length);
			for each (var snapshotObject:Object in foundSnapshots) {
				Assert.assertTrue('each member of the returned snapshots collection should be of type IPopulationSnapshot', snapshotObject is IPopulationSnapshot);
			} 
		}
		
		[Test]
		public function testGetAllPopulationSnapshotsNoLoggedSnapshots():void {
			var foundSnapshots:Array = algorithmLogger.getAllPopulationSnapshots();
			Assert.assertNotNull("returned snapshots array should be non-null even when no populations have been logged");
			Assert.assertStrictlyEquals("returned snapshots collection should have the same length as the number of populations logged", 0, foundSnapshots.length);
		}
		
		[Test]
		public function testGetMaximumGenerationIndex():void {
			populationAlpha.generationIndex = 0;
			algorithmLogger.logPopulation(populationAlpha);
			var inputMaxGenerationIndex:uint = 314;
			populationBeta.generationIndex = inputMaxGenerationIndex;
			algorithmLogger.logPopulation(populationBeta);
			var foundMaxGenerationIndex:uint = algorithmLogger.getMaximumGenerationIndex();
			Assert.assertStrictlyEquals('returned generation index matches highest generation index of all logged populations', inputMaxGenerationIndex, foundMaxGenerationIndex); 
		}
		
		[Test]
		public function testGetMaximumGenerationIndexNoPopulationsLogged():void {
			var foundMaxGenerationIndex:uint = algorithmLogger.getMaximumGenerationIndex();
			Assert.assertStrictlyEquals('returned generation index to be 0 when no populations have been logged', 0, foundMaxGenerationIndex); 
		}
		
		[Test]
		public function testGetPopulationSnapshotByPopulationIdentifier():void {
			var searchId:String = 'arbitrary';
			populationAlpha.id = searchId;
			populationBeta.id = 'beta';
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			var foundSnapshot:IPopulationSnapshot = algorithmLogger.getPopulationSnapshotByPopulationIdentifier(searchId);
			Assert.assertNotNull('returned snapshot should be non-null if appropriate population has been logged', foundSnapshot);
			Assert.assertStrictlyEquals('snapshot should have populationIdentifier that matches searchId', searchId, foundSnapshot.populationIdentifier);
		}
		
		[Test]
		public function testGetPopulationSnapshotByPopulationIdentifierNoSuchPopulationWithId():void {
			var searchId:String = 'arbitrary';
			populationAlpha.id = 'alpha';
			populationBeta.id = 'beta';
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			var foundSnapshot:IPopulationSnapshot = algorithmLogger.getPopulationSnapshotByPopulationIdentifier(searchId);
			Assert.assertNull('returned snapshot should be null if no population with a matching id has been logged', foundSnapshot);
		}
		
		[Test]
		public function testGetPopulationSnapshotByPopulationIdentifierMultipleMatchingIdSameGeneration():void {
			var searchId:String = 'arbitrary';
			populationAlpha.id = searchId;
			populationAlpha.generationIndex = 0;
			populationAlpha.specimens = [new Specimen()];
			populationBeta.id = searchId;
			populationBeta.generationIndex = 0;
			populationBeta.specimens = [new Specimen(), new Specimen()];
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			var foundSnapshot:IPopulationSnapshot = algorithmLogger.getPopulationSnapshotByPopulationIdentifier(searchId);
			Assert.assertNotNull('returned snapshot should be non-null if appropriate population has been logged', foundSnapshot);
			Assert.assertStrictlyEquals('snapshot should have populationIdentifier that matches searchId', searchId, foundSnapshot.populationIdentifier);
			Assert.assertStrictlyEquals('the snapshot returned should correspond to the most recently logged population if both generationIndex and populationIdentifier are the same', 2, foundSnapshot.numberOfSpecimens);
		}
		
		[Test]
		public function testGetPopulationSnapshotByPopulationIdentifierMultipleMatchingIdSameIdentifierDifferentGeneration():void {
			var searchId:String = 'arbitrary';
			populationAlpha.id = searchId;
			populationAlpha.generationIndex = 0;
			populationAlpha.specimens = [new Specimen()];
			populationBeta.id = searchId;
			populationBeta.generationIndex = 1;
			populationBeta.specimens = [new Specimen(), new Specimen()];
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			var foundSnapshot:IPopulationSnapshot = algorithmLogger.getPopulationSnapshotByPopulationIdentifier(searchId);
			Assert.assertNotNull('returned snapshot should be non-null if appropriate population has been logged', foundSnapshot);
			Assert.assertStrictlyEquals('snapshot should have populationIdentifier that matches searchId', searchId, foundSnapshot.populationIdentifier);
			Assert.assertStrictlyEquals('the snapshot returned should correspond to the population with the highest generationIndex if both populationIdentifiers are the same', 2, foundSnapshot.numberOfSpecimens);
		}
		
		[Test]
		public function testGetPopulationSnapshotForGeneration():void {
			var searchIndex:uint = 314;
			populationAlpha.generationIndex = searchIndex;
			populationBeta.generationIndex = 0;
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			
			var foundSnapshot:IPopulationSnapshot = algorithmLogger.getPopulationSnapshotForGeneration(searchIndex);
			Assert.assertNotNull('returned snapshot should be non-null if valid matching population logged', foundSnapshot);
			Assert.assertStrictlyEquals('found snapshot generationIndex matches search index', searchIndex, foundSnapshot.generationIndex); 
		}
		
		[Test]
		public function testGetPopulationSnapshotForGenerationNoPopulationLoggedWithMatchingGeneration():void {
			var searchIndex:uint = 314;
			populationAlpha.generationIndex = 0;
			populationBeta.generationIndex = 1;
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			
			var foundSnapshot:IPopulationSnapshot = algorithmLogger.getPopulationSnapshotForGeneration(searchIndex);
			Assert.assertNull('returned snapshot should be null if no population logged with the target generation index', foundSnapshot);
		}
		
		[Test]
		public function testGetPopulationSnapshotForGenerationWithMultipleMatchingGeneration():void {
			var searchIndex:uint = 314;
			populationAlpha.generationIndex = searchIndex;
			populationAlpha.specimens = [new Specimen()];
			populationBeta.generationIndex = searchIndex;
			populationBeta.specimens = [new Specimen(), new Specimen()];
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			
			var foundSnapshot:IPopulationSnapshot = algorithmLogger.getPopulationSnapshotForGeneration(searchIndex);
			Assert.assertNotNull('returned snapshot should be non-null if valid matching population logged', foundSnapshot);
			Assert.assertStrictlyEquals('found snapshot generationIndex matches search index', searchIndex, foundSnapshot.generationIndex); 
			Assert.assertStrictlyEquals('found snapshot should correspond to the most recently logged population if multiple populations have the same generationIndex', 2, foundSnapshot.numberOfSpecimens);
		}
		
		[Test]
		public function testGetTopSpecimen():void {
			var mediocreSpecimen:ISpecimen = new Specimen();
			mediocreSpecimen.fitness = 1;
			populationAlpha.specimens = [mediocreSpecimen];
			
			var goodSpecimen:ISpecimen = new Specimen();
			goodSpecimen.fitness = 10;
			populationBeta.specimens = [goodSpecimen];
			
			algorithmLogger.logPopulation(populationAlpha);
			algorithmLogger.logPopulation(populationBeta);
			var topSpecimen:ISpecimen = algorithmLogger.getTopSpecimen();
			
			Assert.assertStrictlyEquals('Returns best of the logged specimens', goodSpecimen, topSpecimen);
		}
		
		[Test]
		public function testLogAlgorithmStart():void {
			var currentTime:Date = new Date();
			timeA = currentTime.time;
			algorithmLogger.logAlgorithmStart();
			var foundStartTime:Date = algorithmLogger.getAlgorithmStartTime();
			Assert.assertNotNull('logged start time should be non-null', foundStartTime);
			Assert.assertTrue('logged start time should match current time', valueWithinTolerance(foundStartTime.time, currentTime.time, 10));
		}
		
		[Test(async)]
		public function testLogAlgorithmStartAsync():void {
			timeA = (new Date()).time;
			algorithmLogger.logAlgorithmStart();
			asyncTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, logAlgorithmStartAsyncFollowUpHandler, 500));
			asyncTimer.start();
		}
		
		private function logAlgorithmStartAsyncFollowUpHandler(timerEvent:TimerEvent, passThroughData:Object = null):void {
			asyncTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, logAlgorithmStartAsyncFollowUpHandler);
			var foundStartTime:Date = algorithmLogger.getAlgorithmStartTime();
			Assert.assertNotNull('logged start time should be non-null', foundStartTime);
			Assert.assertTrue('logged start time should match original starting time', valueWithinTolerance(foundStartTime.time, timeA, TIME_IMPRECISION_TOLERANCE));
		}
		
		[Test(async)]
		public function testLogAlgorithmStartMultipleStart():void {
			timeA = new Date().time;
			algorithmLogger.logAlgorithmStart();
			asyncTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, logAlgorithmStartMultipleStartFollowUpHandler, 500));
			asyncTimer.start();
		}
		
		private function logAlgorithmStartMultipleStartFollowUpHandler(timerEvent:TimerEvent, passThroughData:Object = null):void {
			asyncTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, logAlgorithmStartMultipleStartFollowUpHandler);
			var currentTime:Date = new Date();
			algorithmLogger.logAlgorithmStart();
			var foundStartTime:Date = algorithmLogger.getAlgorithmStartTime();
			Assert.assertNotNull('logged start time should be non-null', foundStartTime);
			Assert.assertFalse('logged start time should match original starting time, not current time, if already started', currentTime.time == foundStartTime.time);
			Assert.assertTrue('logged start time should match original starting time', valueWithinTolerance(foundStartTime.time, timeA, TIME_IMPRECISION_TOLERANCE));
		}
		
		[Test]
		public function testGetAlgorithStartTimeNoStartLogged():void {
			var foundStartTime:Date = algorithmLogger.getAlgorithmStartTime();
			Assert.assertNull('returned start time should be null if the algorithm has not started', foundStartTime);
		}
		
		[Test]
		public function testGetAlgorithmStopTime():void {
			algorithmLogger.logAlgorithmStart();
			algorithmLogger.logAlgorithmStop();
			var foundStopTime:Date = algorithmLogger.getAlgorithmStopTime();
			Assert.assertNotNull('returned stop time should be non-null if validly stopped', foundStopTime);
			Assert.assertTrue('returned stop time should match last valid stop', valueWithinTolerance(foundStopTime.time, new Date().time, TIME_IMPRECISION_TOLERANCE));
		}
		
		[Test]
		public function testGetAlgorithmStopTimeStillRunning():void {
			algorithmLogger.logAlgorithmStart();
			var foundStopTime:Date = algorithmLogger.getAlgorithmStopTime();
			Assert.assertNull('returned stop time should be null if the algorithm is still running', foundStopTime);
		}
		
		[Test]
		public function testGetAlgorithmStopTimeNeverStarted():void {
			algorithmLogger.logAlgorithmStop();
			var foundStopTime:Date = algorithmLogger.getAlgorithmStopTime();
			Assert.assertNull('returned stop time should be null if the algorithm was never started', foundStopTime);
		}
		
		[Test]
		public function testGetAlgorithmStopTimeNeverStartedOrStopped():void {
			var foundStopTime:Date = algorithmLogger.getAlgorithmStopTime();
			Assert.assertNull('returned stop time should be null if the algorithm was never started or stopped', foundStopTime);
		}
		
		[Test(async)]
		public function testLogAlgorithmStopMultiple():void {
			algorithmLogger.logAlgorithmStart();
			algorithmLogger.logAlgorithmStop();
			timeA = algorithmLogger.getAlgorithmStopTime().time;
			asyncTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, logAlgorithmStopMultipleFollowUpHandler, 500));
			asyncTimer.start();
		}
		
		private function logAlgorithmStopMultipleFollowUpHandler(timerEvent:TimerEvent, passThroughData:Object = null):void {
			asyncTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, logAlgorithmStopMultipleFollowUpHandler);
			var foundStopTime:Date = algorithmLogger.getAlgorithmStopTime();
			Assert.assertNotNull('logged stop time should be non-null', foundStopTime);
			Assert.assertStrictlyEquals('logged stop time should match original stop time', timeA, foundStopTime.time);
			Assert.assertFalse('logged stop time should not match current time', foundStopTime.time == new Date().time);
		}
		
		[Test]
		public function testGetAlgorithmRunningDuration():void {
			algorithmLogger.logAlgorithmStart();
			algorithmLogger.logAlgorithmStop();
			var duration:uint = algorithmLogger.getAlgorithmRunningDuration();
			Assert.assertTrue('running duration should be 0 for synchronous immediate start/stop calls', valueWithinTolerance(duration, 0, TIME_IMPRECISION_TOLERANCE/2));
		}
		
		[Test(async)]
		public function testGetAlgorithmRunningDurationAsync():void {
			algorithmLogger.logAlgorithmStart();
			asyncTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, getAlgorithmRunningDurationAsyncHandler, 500));
			asyncTimer.start();
		}
		
		private function getAlgorithmRunningDurationAsyncHandler(timerEvent:TimerEvent, passThroughData:Object = null):void {
			algorithmLogger.logAlgorithmStop();
			var duration:uint = algorithmLogger.getAlgorithmRunningDuration();
			Assert.assertTrue('running duration should match difference between start and stop times', valueWithinTolerance(duration, uint(asyncTimer.delay), TIME_IMPRECISION_TOLERANCE*2));
			asyncTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, getAlgorithmRunningDurationAsyncHandler);
		}
		
		[Test]
		public function testLogPopulation():void {
			populationAlpha.id = 'unique identifier';
			algorithmLogger.logPopulation(populationAlpha);
			Assert.assertStrictlyEquals('algorithm logger contains IPopulationSnapshot with id matching input population', populationAlpha.id, algorithmLogger.getAllPopulationSnapshots()[0].populationIdentifier);
		}
	}
}