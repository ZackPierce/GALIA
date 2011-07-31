package galia.termination
{
	import flexunit.framework.Assert;
	
	import galia.base.AlgorithmLogger;
	import galia.base.Population;
	import galia.base.Specimen;
	import galia.core.IAlgorithmLogger;
	import galia.core.IPopulation;
	import galia.core.ISpecimen;
	
	public class MaxFitnessOverThresholdTest
	{
		private var algorithmLogger:IAlgorithmLogger;
		private var maxFitnessOverThreshold:MaxFitnessOverThreshold;
		private var threshold:Number;
		private var population:IPopulation;
		private var specimen:ISpecimen;
		
		[Before]
		public function setUp():void {
			algorithmLogger = new AlgorithmLogger();
			maxFitnessOverThreshold = new MaxFitnessOverThreshold();
			threshold = Number.MAX_VALUE;
			specimen = new Specimen();
			population = new Population(0, 'id', [specimen]);
		}
		
		[After]
		public function tearDown():void {
			algorithmLogger = null;
			maxFitnessOverThreshold = null;
			threshold = Number.MAX_VALUE;
			population = null;
			specimen = null;
		}
		
		[Test]
		public function testTerminationConditionSatisfied():void {
			threshold = 10;
			maxFitnessOverThreshold.targetFitnessThreshold = threshold;
			specimen.fitness = 15;
			algorithmLogger.logPopulation(population);
			var result:Boolean = maxFitnessOverThreshold.isTerminationConditionSatisfied(algorithmLogger);
			Assert.assertTrue('termination condition should be satisfied if at least one specimen in any population has a fitness value exceeding the threshold', result);
		}
		
		[Test]
		public function testTerminationConditionSatisfiedNotOverThreshold():void {
			threshold = 10;
			maxFitnessOverThreshold.targetFitnessThreshold = threshold;
			specimen.fitness = 0;
			algorithmLogger.logPopulation(population);
			var result:Boolean = maxFitnessOverThreshold.isTerminationConditionSatisfied(algorithmLogger);
			Assert.assertFalse('termination condition should not be satisfied no specimen in any population has a fitness value exceeding the threshold', result);
		}
		
		[Test]
		public function testTerminationConditionSatisfiedNullLogger():void {
			algorithmLogger = null;
			var result:Boolean = maxFitnessOverThreshold.isTerminationConditionSatisfied(algorithmLogger);
			Assert.assertFalse('termination condition should not be satisfied if no algorithmLogger is provided', result);
		}
	}
}