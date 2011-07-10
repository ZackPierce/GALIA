package galia.populationEvolution
{
	import galia.base.Specimen;
	import galia.core.IChromosome;
	import galia.core.IPopulationEvolutionOperator;
	import galia.core.IProcreationOperator;
	import galia.core.IRandomNumberGenerator;
	import galia.core.ISpecimen;
	import galia.math.MathRandomNumberGenerator;
	
	public class PopulationEvolutionByProcreation implements IPopulationEvolutionOperator
	{
		private var _chromosomeProcreationOperator:IProcreationOperator;
		private var _chromosomeType:Class;
		public var randomNumberGenerator:IRandomNumberGenerator = new MathRandomNumberGenerator();
		
		public function PopulationEvolutionByProcreation(chromosomeProcreationOperator:IProcreationOperator = null) {
			this.chromosomeProcreationOperator = chromosomeProcreationOperator;
		}
		
		public function evolvePopulation(specimens:Array, targetPopulationSize:uint):Array {
			var population:Array = [];
			if (!chromosomeProcreationOperator || (chromosomeProcreationOperator.numberOfParentsRequired > 0 && (!specimens || specimens.length < chromosomeProcreationOperator.numberOfParentsRequired))) {
				return generateEmptySpecimens(targetPopulationSize);
			}
			
			if (chromosomeProcreationOperator.numberOfParentsRequired == 0) {
				return generateSpecimensFromChromosomeProcreationOperatorWithoutParents(targetPopulationSize);
			}
			
			var parentSpecimenIndex:int = 0;
			while (population.length < targetPopulationSize) {
				var parentChromosomes:Array = [];
				var primeParentChromosome:IChromosome = (specimens[parentSpecimenIndex] as ISpecimen).chromosome;
				parentChromosomes.push(primeParentChromosome);
				parentSpecimenIndex = parentSpecimenIndex < specimens.length - 1 ? parentSpecimenIndex + 1 : 0;

				while(parentChromosomes.length < chromosomeProcreationOperator.numberOfParentsRequired) {
					parentChromosomes.push((specimens[randomNumberGenerator.integer(0, specimens.length)] as ISpecimen).chromosome);
				}
				var kidChromosomes:Array = chromosomeProcreationOperator.procreate(parentChromosomes);
				while (kidChromosomes.length > 0 && population.length < targetPopulationSize) {
					var chromosome:IChromosome = kidChromosomes.pop();
					var specimen:ISpecimen = new Specimen();
					specimen.chromosome = chromosome;
					population.push(specimen);
				}
			}
			
			return population;
		}
		
		protected function generateEmptySpecimens(numberOfSpecimens:uint):Array {
			var specimens:Array = [];
			for (var i:int = 0; i < numberOfSpecimens; i++) {
				var specimen:ISpecimen = new Specimen();
				if (chromosomeType) {
					specimen.chromosome = new chromosomeType();
				}
				specimens.push(new Specimen());
			}
			return specimens;
		}
		
		protected function generateSpecimensFromChromosomeProcreationOperatorWithoutParents(targetPopulationSize:uint):Array {
			var specimens:Array = [];
			while (specimens.length < targetPopulationSize) {
				var kidChromosomes:Array = chromosomeProcreationOperator.procreate([]);
				while (specimens.length < targetPopulationSize && kidChromosomes.length > 0) {
					var specimen:ISpecimen = new Specimen();
					specimen.chromosome = kidChromosomes.pop();
					specimens.push(specimen);
				}
			}
			return specimens;
		}
		
		public function get chromosomeProcreationOperator():IProcreationOperator {
			return _chromosomeProcreationOperator;
		}
		
		public function set chromosomeProcreationOperator(value:IProcreationOperator):void {
			_chromosomeProcreationOperator = value;
		}
		
		public function get chromosomeType():Class {
			return _chromosomeType;
		}
		
		public function set chromosomeType(value:Class):void {
			_chromosomeType = value;
		}
	}
}