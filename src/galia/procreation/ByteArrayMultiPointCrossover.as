package galia.procreation
{
	import com.gskinner.utils.Rndm;
	
	import flash.utils.ByteArray;
	
	import galia.base.ByteArrayChromosome;
	import galia.core.IProcreationOperator;
	
	public class ByteArrayMultiPointCrossover implements IProcreationOperator
	{
		private var _numberOfCrossoverPoints:uint = 1;
		
		private var randomNumberGenerator:Rndm = new Rndm(Math.random()*uint.MAX_VALUE);
		
		public function ByteArrayMultiPointCrossover(numberOfCrossoverPoints:uint = 1) {
			_numberOfCrossoverPoints = numberOfCrossoverPoints;
		}
		
		public function procreate(parentChromosomes:Array):Array {
			if (!parentChromosomes || parentChromosomes.length < numberOfParentsRequired) {
				return [];
			}
			var children:Array = [];
			var numberOfParents:uint = parentChromosomes.length;
			var scrap:ByteArray = new ByteArray();
			for (var i:int = 0; i < numberOfParents; i += 2) {
				var parentA:ByteArray = parentChromosomes[i];
				var parentB:ByteArray; 
				if (i < numberOfParents - 1) {
					parentB = parentChromosomes[i + 1];
				} else {
					parentB = parentChromosomes[randomNumberGenerator.integer(0, i + 1)];
				}
				var kidA:ByteArrayChromosome = new ByteArrayChromosome(parentA);
				var kidB:ByteArrayChromosome = new ByteArrayChromosome(parentB);
				children.push(kidA);
				if (children.length < numberOfParents) {
					children.push(kidB);
				}
				var chromosomeLength:uint = parentA.length;
				if (chromosomeLength < 1) {
					continue;
				}
				
				var crossoverPoints:Array = [];
				for (var j:int = 0; j < numberOfCrossoverPoints; j++) {
					crossoverPoints.push(randomNumberGenerator.integer(0, chromosomeLength));
				}
				crossoverPoints.sort(Array.NUMERIC);
				for (var k:int = 0; k < numberOfCrossoverPoints; k += 2) {
					var startPoint:int = crossoverPoints[k];
					var endPoint:int = k < numberOfCrossoverPoints - 1 ? crossoverPoints[k + 1] : chromosomeLength - 1;
					var cutLength:int = endPoint - startPoint + 1;
					kidA.position = startPoint;
					kidB.position = startPoint;
					scrap.position = 0;
					scrap.writeBytes(kidA, startPoint, cutLength);
					kidA.writeBytes(kidB, startPoint, cutLength);
					kidB.writeBytes(scrap, 0, cutLength);
				}
			}
			return children;
		}
		
		public function get numberOfParentsRequired():uint {
			return 2;
		}
		
		public function get numberOfCrossoverPoints():uint {
			return _numberOfCrossoverPoints;
		}
		
		public function set numberOfCrossoverPoints(value:uint):void {
			_numberOfCrossoverPoints = value;
		}
		
		public function get seed():uint {
			return randomNumberGenerator.seed;
		}
		
		public function set seed(value:uint):void {
			randomNumberGenerator.seed = value;
		}
	}
}