package screens 
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import util.Config;
	import util.AssetManager;
	import util.ArrayUtil;
	import ao.ExternalStorageAO;
	
	/**
	 * The settings screen of the application
	 * @author Johan
	 */
	public class SettingsScreen extends BaseScreen 
	{
		private var difficultyBtn:Button;
		private var durationBtn:Button;
		private var exitBtn:Button;
		
		private var difficultyText:TextField;
		private var durationText:TextField;
		
		private var generatedChoices:Vector.<Button>;
		
		/**
		 * Constructor of SettingsScreen
		 * @param	main
		 */
		public function SettingsScreen(main:ScreenMaster) 
		{
			super(main);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		/**
		 * Initializes the assets that will be used in this screen. The event listeners will also be set
		 * @param	event
		 */
		public function initialize(event:Event):void {
			putLogoOnScreen();
			durationText = new TextField(120, 40, "Duration");
			durationText.x = Config.SPACING_LEFT_PX;
			durationText.y = getLogo().height + Config.SPACING_ABOVE_PX;
			
			difficultyText = new TextField(120, 40, "Difficulty");
			difficultyText.x = Config.SPACING_LEFT_PX;
			difficultyText.y = durationText.y + Config.SPACING_ABOVE_PX + durationText.height;
			
			exitBtn = new Button(AssetManager.getSingleAsset("ui", "MenuBtn"));
			setButtonAttributes((stage.stageWidth - exitBtn.width) / 2, difficultyText.y + Config.SPACING_ABOVE_PX + difficultyText.height, exitBtn, "Back to menu");
			
			addChild(difficultyText);
			addChild(durationText);
			addChild(exitBtn);
			
			exitBtn.addEventListener(Event.TRIGGERED, toStart);
			updateButtons();
		}
		
		/**
		 * Will show the different options of the touched setting
		 * @param	event
		 */
		private function showDifferentSettings(event:Event):void {
			exitBtn.visible = false;
			if (generatedChoices == null) {
				generatedChoices = new Vector.<Button>();
			}
			
			if (generatedChoices.length == 0) {
				var button:Button = event.target as Button;
				generatedChoices.push(button);
				if (button == difficultyBtn) {
					createChoices(Config.DIFFICULTY_SETTINGS, button);
				} else if (button == durationBtn) {
					createChoices(Config.DURATION_SETTINGS, button);
				}
			}
		}
		
		/**
		 * Saves the changes to the settings to the external storage of the phone
		 * @param	event
		 */
		private function saveChanges(event:Event):void {
			var btn:Button = event.target as Button;
			
			while (generatedChoices.length != 0) {
				var oldBtn:Button = generatedChoices.pop();
				removeChild(oldBtn);
				if (generatedChoices.length == 0) { //last element
					setButtonAttributes(oldBtn.x, oldBtn.y, btn, btn.text);
					addChild(btn);
					btn.removeEventListener(Event.TRIGGERED, saveChanges);
					btn.addEventListener(Event.TRIGGERED, showDifferentSettings);
					
					if (ArrayUtil.inArray(Config.DURATION_SETTINGS, btn.text)) durationBtn = btn
					else if (ArrayUtil.inArray(Config.DIFFICULTY_SETTINGS, btn.text)) difficultyBtn = btn;
				}
			}
			ExternalStorageAO.saveFile(Config.SAVE_SETTINGS_FILE, "duration_"+durationBtn.text+";difficulty_"+difficultyBtn.text);
			exitBtn.visible = true;
		}
		
		/**
		 * Creates the choices of a given setting
		 * @param	choices
		 * @param	button
		 */
		private function createChoices(choices:Array, button:Button):void {
			button.removeEventListener(Event.TRIGGERED, showDifferentSettings);
			button.addEventListener(Event.TRIGGERED, saveChanges);
			var previousBtn:Button = button;
			for (var i:int = 0; i < choices.length; i++) {
				if (button.text != choices[i]) {
					var newBtn:Button = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
					setButtonAttributes(previousBtn.x, previousBtn.y + previousBtn.height + Config.SPACING_ABOVE_PX, newBtn, choices[i]);
					addChild(newBtn);
					newBtn.addEventListener(Event.TRIGGERED, saveChanges);
					generatedChoices.push(newBtn);
					previousBtn = newBtn;
				}
			}
		}
		
		/**
		 * Updates the button to show the correct values for each of the settings. Either using the stored data or, when stored data 
		 * isn't available, using the default values located in the Config file
		 */
		private function updateButtons():void {
			var settings:String = ExternalStorageAO.loadFile(Config.SAVE_SETTINGS_FILE);
			difficultyBtn = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			durationBtn = new Button(AssetManager.getSingleAsset("ui", "SettingsChoiceBtn"));
			if (settings != "" && settings != null) {
				var map:Object = ArrayUtil.getValuePair(settings);
				setButtonAttributes(stage.stageWidth - (Config.SPACING_RIGHT_PX + difficultyBtn.width),  difficultyText.y, difficultyBtn, map.difficulty);
				setButtonAttributes(stage.stageWidth - (Config.SPACING_RIGHT_PX + durationBtn.width), durationText.y, durationBtn, map.duration);
			} else {
				setButtonAttributes(stage.stageWidth - (Config.SPACING_RIGHT_PX + difficultyBtn.width),  difficultyText.y, difficultyBtn, Config.DIFFICULTY_SETTINGS[Config.STANDARD_DIFFICULTY_SETTING]);
				setButtonAttributes(stage.stageWidth - (Config.SPACING_RIGHT_PX + durationBtn.width), durationText.y, durationBtn, Config.DURATION_SETTINGS[Config.STANDARD_DURATION_SETTING]);
			}
			
			addChild(difficultyBtn);
			addChild(durationBtn);
			
			difficultyBtn.addEventListener(Event.TRIGGERED, showDifferentSettings);
			durationBtn.addEventListener(Event.TRIGGERED, showDifferentSettings);
		}
	}

}