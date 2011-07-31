package galia.seeding.supportClasses
{
	import galia.core.ISeedingStrategy;
	import galia.populationEvolution.supportClasses.TrivialChromosome;
	
	public class TrivialChromosomeSeedingStrategy implements ISeedingStrategy
	{
		public var numGenerateChromosomesCalls:uint = 0;
		
		public function TrivialChromosomeSeedingStrategy() {
		}
		
		public function generateChromosomes(numberOfChromosomes:uint):Array {
			numGenerateChromosomesCalls++;
			var chromosomes:Array = [];
			for (var i:uint = 0; i < numberOfChromosomes; i++) {
				chromosomes.push(new TrivialChromosome());
			}
			return chromosomes;
		}
	}
}