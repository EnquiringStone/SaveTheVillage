package screens 
{
	/**
	 * ...
	 * @author Johan
	 */
	public class ScoreScreen extends BaseScreen 
	{
		private var score:int;
		
		public function ScoreScreen(main:ScreenMaster, score:String) 
		{
			super(main);
			this.score = parseInt(score);
		}
		
	}

}