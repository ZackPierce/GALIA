package galia.termination
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flexunit.framework.Assert;
	
	import galia.base.AlgorithmLogger;
	import galia.base.Population;
	import galia.base.Specimen;
	import galia.core.IAlgorithmLogger;
	import galia.core.IPopulation;
	import galia.core.ISpecimen;
	
	import org.flexunit.async.Async;
	
	public class ActiveRunningTimeOverDurationLimitTest
	{		
		private var algorithmLogger:IAlgorithmLogger;
		private var maxGenerationIndex:ActiveRunningTimeOverDurationLimit;
		private var threshold:uint;
		private var asyncTimer:Timer;
		
		[Before]
		public function setUp():void {
			algorithmLogger = new AlgorithmLogger();
			maxGenerationIndex = new ActiveRunningTimeOverDurationLimit();
			threshold = uint.MAX_VALUE;
			asyncTimer = new Timer(100, 1);
		}
		
		[After]
		public function tearDown():void {
			algorithmLogger = null;
			maxGenerationIndex = null;
			threshold = uint.MAX_VALUE;
			if (asyncTimer) {
				asyncTimer.stop();
			}
			asyncTimer = null;
		}
		
		[Test(async)]
		public function testTerminationConditionSatisfied():void {
			threshold = 10;
			maxGenerationIndex.durationLimitInMilliseconds = threshold;
			algorithmLogger.logAlgorithmStart();
			asyncTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, testTerminationConditionSatisfiedHandler, 200)); 
			asyncTimer.start();
		}
		
		private function testTerminationConditionSatisfiedHandler(event:TimerEvent, passThroughData:Object = null):void {
			var result:Boolean = maxGenerationIndex.terminationConditionSatisfied(algorithmLogger);
			Assert.assertTrue('termination condition should be satisfied if time past starting point exceeds threshold duration', result);
			asyncTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, testTerminationConditionSatisfiedHandler);
		}
		
		[Test(async)]
		public function testTerminationConditionSatisfiedNotOverThreshold():void {
			threshold = 1000;
			maxGenerationIndex.durationLimitInMilliseconds = threshold;
			algorithmLogger.logAlgorithmStart();
			asyncTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Async.asyncHandler(this, testTerminationConditionSatisfiedHandlerNotOverThreshold, 200)); 
			asyncTimer.start();
		}
		
		private function testTerminationConditionSatisfiedHandlerNotOverThreshold(event:TimerEvent, passThroughData:Object = null):void {
			var result:Boolean = maxGenerationIndex.terminationConditionSatisfied(algorithmLogger);
			Assert.assertFalse('termination condition should not be satisfied if time past starting point is under threshold duration', result);
			asyncTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, testTerminationConditionSatisfiedHandlerNotOverThreshold);
		}
		
		[Test]
		public function testTerminationConditionSatisfiedNullLogger():void {
			algorithmLogger = null;
			var result:Boolean = maxGenerationIndex.terminationConditionSatisfied(algorithmLogger);
			Assert.assertFalse('termination condition should not be satisfied if no algorithmLogger is provided', result);
		}
	}
}