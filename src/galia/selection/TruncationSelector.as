package galia.selection
{
	import com.gskinner.utils.Rndm;
	
	import galia.core.ISelector;
	
	public class TruncationSelector extends BaseSelector implements ISelector
	{
		public function TruncationSelector(numberOfSelections:uint = 0) {
			super(numberOfSelections);
		}
		
		override public function selectSurvivors(specimens:Array):Array {
			if (!specimens || specimens.length == 0 || numberOfSelections == 0) {
				return [];
			}
			var localSpecimens:Array = specimens.concat();
			SelectionUtil.sortSpecimensByFitness(localSpecimens, Array.DESCENDING);
			var numAvailableSpecimens:uint = localSpecimens.length;
			if (numberOfSelections < numAvailableSpecimens) {
				return localSpecimens.slice(0, numberOfSelections);
			} else {
				var selectedSpecimens:Array = localSpecimens.concat();
				var index:int = 0;
				while (selectedSpecimens.length < numberOfSelections) {
					selectedSpecimens.push(localSpecimens[index]);
					index++;
					if (index >= numAvailableSpecimens) {
						index = 0;
					}
				}
				return selectedSpecimens;
			}
			
		}
	}
}