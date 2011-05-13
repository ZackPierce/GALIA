package galia.selection.supportClasses
{
	import galia.core.ISelector;
	
	public class TrivialSelector implements ISelector
	{
		private var _numberOfSelections:uint = 0;
		
		public function TrivialSelector()
		{
		}
		
		public function selectSurvivors(specimens:Array):Array
		{
			if (!specimens || specimens.length == 0 || numberOfSelections == 0) {
				return [];
			}
			var selectedSpecimens:Array = [];
			while (selectedSpecimens.length < numberOfSelections) {
				selectedSpecimens.push(specimens[0]);
			}
			return selectedSpecimens;
		}
		
		public function get numberOfSelections():uint
		{
			return _numberOfSelections;
		}
		
		public function set numberOfSelections(value:uint):void
		{
			_numberOfSelections = value;
		}
	}
}