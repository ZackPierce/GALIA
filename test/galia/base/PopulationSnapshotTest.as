package galia.base
{
	import flexunit.framework.Assert;
	
	public class PopulationSnapshotTest
	{	
		private var snapshot:PopulationSnapshot;
		private var specimens:Array;
		
		[Before]
		public function setUp():void {
			
		}
		
		[After]
		public function tearDown():void {
			snapshot = null;
			specimens = null;
		}
		
		[Test]
		public function testGeneratePopulationSnapshot():void {
			specimens = [new Specimen(), new Specimen(), new Specimen()];
			specimens[0].fitness = 1;
			specimens[1].fitness = 2;
			specimens[2].fitness = 3;
			var generationIndexInput:uint = 4;
			var populationIdentifierInput:String = 'one a';
			snapshot = PopulationSnapshot.generatePopulationSnapshot(generationIndexInput, populationIdentifierInput, specimens);
			Assert.assertStrictlyEquals('snapshot generationIndex property matches input parameter', generationIndexInput, snapshot.generationIndex);
			Assert.assertStrictlyEquals('snapshot populationIdentifier property matches input parameter', populationIdentifierInput, snapshot.populationIdentifier);
			Assert.assertStrictlyEquals('max property should match expected value', 3, snapshot.maxFitness);
			Assert.assertStrictlyEquals('mean property should match expected value', 2, snapshot.meanFitness);
			Assert.assertStrictlyEquals('median property should match expected value', 2, snapshot.medianFitness);
			Assert.assertStrictlyEquals('min property should match expected value', 1, snapshot.minFitness);
			Assert.assertStrictlyEquals('numberOfSpecimens property should match expected value', 3, snapshot.numberOfSpecimens);
			Assert.assertStrictlyEquals('topSpecimen should match expected value', specimens[2], snapshot.topSpecimen); 
			Assert.assertStrictlyEquals('standardDeviation property should match expected value', Math.sqrt(2.0/3.0).toPrecision(15), snapshot.standardDeviationFitness.toPrecision(15));
		}
	}
}