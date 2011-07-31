package galia.termination
{
	import flexunit.framework.Assert;
	
	import galia.base.AlgorithmLogger;
	import galia.base.Population;
	import galia.base.Specimen;
	import galia.core.IAlgorithmLogger;
	import galia.core.IPopulation;
	import galia.core.ISpecimen;
	
	public class MaxGenerationIndexTest
	{		
		private var algorithmLogger:IAlgorithmLogger;
		private var maxGenerationIndex:MaxGenerationIndex;
		private var threshold:uint;
		private var population:IPopulation;
		private var specimen:ISpecimen;
		
		[Before]
		public function setUp():void {
			algorithmLogger = new AlgorithmLogger();
			maxGenerationIndex = new MaxGenerationIndex();
			threshold = uint.MAX_VALUE;
			specimen = new Specimen();
			population = new Population(0, 'id', [specimen]);
		}
		
		[After]
		public function tearDown():void {
			algorithmLogger = null;
			maxGenerationIndex = null;
			threshold = uint.MAX_VALUE;
			population = null;
			specimen = null;
		}
		
		[Test]
		public function testTerminationConditionSatisfied():void {
			threshold = 10;
			maxGenerationIndex.maximumGenerationIndex = threshold;
			population.generationIndex = 15;
			algorithmLogger.logPopulation(population);
			var result:Boolean = maxGenerationIndex.isTerminationConditionSatisfied(algorithmLogger);
			Assert.assertTrue('termination condition should be satisfied if at least one population has a generationIndex value exceeding the threshold', result);
		}
		
		[Test]
		public function testTerminationConditionSatisfiedNotOverThreshold():void {
			threshold = 10;
			maxGenerationIndex.maximumGenerationIndex = threshold;
			population.generationIndex = 0;
			algorithmLogger.logPopulation(population);
			var result:Boolean = maxGenerationIndex.isTerminationConditionSatisfied(algorithmLogger);
			Assert.assertFalse('termination condition should not be satisfied no population has a generationIndex value exceeding the threshold', result);
		}
		
		[Test]
		public function testTerminationConditionSatisfiedNullLogger():void {
			algorithmLogger = null;
			var result:Boolean = maxGenerationIndex.isTerminationConditionSatisfied(algorithmLogger);
			Assert.assertFalse('termination condition should not be satisfied if no algorithmLogger is provided', result);
		}
	}
}