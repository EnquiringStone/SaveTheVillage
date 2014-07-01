package screens 
{
	import gamelogic.EconomyLogic;
	import starling.events.Event;
	/**
	 * ...
	 * @author Johan
	 */
	public class VillageDetailScreen extends StructureScreen 
	{
		public function VillageDetailScreen(mainGame:MainGameScreen, information:Object) 
		{
			super(mainGame, information);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function addedToStage(event:Event):void {
			initialize(event);
			if (!this.getMainGame().getMapLogic().isDead(this.getInfo().name)) {
				addInfoField();
				addDataField();
				addBuyButton();
				addSpecificDetails();
			} else {
				this.createDeadText();
			}
			
		}
	}

}