package ui.screens.display.settings.share
{
	import database.CommonSettings;
	import database.LocalSettings;
	
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ArrayCollection;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.themes.BaseMaterialDeepGreyAmberMobileTheme;
	
	import model.ModelLocator;
	
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
	import ui.screens.display.LayoutFactory;
	import ui.screens.display.SpikeList;
	
	import utils.Constants;
	
	[ResourceBundle("globaltranslations")]
	[ResourceBundle("sharesettingsscreen")]

	public class AppBadgeSettingsList extends SpikeList 
	{
		/* Display Objects */
		private var appBadgeToggle:ToggleSwitch;
		private var mmolMultiplierCheck:Check;
		private var mmolMultiplierLabel:Label;
		
		/* Properties */
		public var needsSave:Boolean = false;
		private var appBadgeEnabled:Boolean;
		private var mmolMultiplierEnabled:Boolean;
		
		public function AppBadgeSettingsList()
		{
			super();
		}
		override protected function initialize():void 
		{
			super.initialize();
			
			setupProperties();
			setupInitialState();
			setupContent();
		}
		
		/**
		 * Functionality
		 */
		private function setupProperties():void
		{
			//Set Properties
			clipContent = false;
			isSelectable = false;
			autoHideBackground = true;
			hasElasticEdges = false;
			paddingBottom = 5;
			width = Constants.stageWidth - (2 * BaseMaterialDeepGreyAmberMobileTheme.defaultPanelPadding);
		}
		
		private function setupInitialState():void
		{
			if (LocalSettings.getLocalSetting(LocalSettings.LOCAL_SETTING_ALWAYS_ON_APP_BADGE) == "true") appBadgeEnabled = true;
			else appBadgeEnabled = false;
			
			if (LocalSettings.getLocalSetting(LocalSettings.LOCAL_SETTING_APP_BADGE_MMOL_MULTIPLIER_ON) == "true") mmolMultiplierEnabled = true;
			else mmolMultiplierEnabled = false;
		}
		
		private function setupContent():void
		{
			//Notifications On/Off Toggle
			appBadgeToggle = LayoutFactory.createToggleSwitch(appBadgeEnabled);
			appBadgeToggle.addEventListener(Event.CHANGE, onAppBadgeChanged);
			
			//Mmmol multiplier
			mmolMultiplierCheck = LayoutFactory.createCheckMark(mmolMultiplierEnabled);
			mmolMultiplierCheck.addEventListener(Event.CHANGE, onMMOLMultiplierChanged);
			
			//Mmmol multiplier description
			mmolMultiplierLabel = LayoutFactory.createLabel(ModelLocator.resourceManagerInstance.getString('sharesettingsscreen','mmol_multiplier_description'), HorizontalAlign.JUSTIFY);
			mmolMultiplierLabel.wordWrap = true; 
			mmolMultiplierLabel.width = width - 20;
			mmolMultiplierLabel.paddingTop = mmolMultiplierLabel.paddingBottom = 10;
			
			(layout as VerticalLayout).hasVariableItemDimensions = true;
			
			refreshContent();
		}
		
		private function refreshContent():void
		{
			var content:Array = [];
			content.push( { label: ModelLocator.resourceManagerInstance.getString('globaltranslations','enabled'), accessory: appBadgeToggle } );
			if (CommonSettings.getCommonSetting(CommonSettings.COMMON_SETTING_DO_MGDL) != "true")
			{
				content.push( { label: ModelLocator.resourceManagerInstance.getString('sharesettingsscreen','mmol_multiplier_label'), accessory: mmolMultiplierCheck } );
				content.push( { label: "", accessory: mmolMultiplierLabel } );
			}
				
			
			dataProvider = new ArrayCollection(content);
		}
		
		public function save():void
		{
			if(LocalSettings.getLocalSetting(LocalSettings.LOCAL_SETTING_ALWAYS_ON_APP_BADGE) != String(appBadgeEnabled))
				LocalSettings.setLocalSetting(LocalSettings.LOCAL_SETTING_ALWAYS_ON_APP_BADGE, String(appBadgeEnabled));
			
			if(LocalSettings.getLocalSetting(LocalSettings.LOCAL_SETTING_APP_BADGE_MMOL_MULTIPLIER_ON) != String(mmolMultiplierEnabled))
				LocalSettings.setLocalSetting(LocalSettings.LOCAL_SETTING_APP_BADGE_MMOL_MULTIPLIER_ON, String(mmolMultiplierEnabled));
			
			needsSave = false;
		}
		
		/**
		 * Event Handlers
		 */
		private function onAppBadgeChanged(e:Event):void
		{
			appBadgeEnabled = appBadgeToggle.isSelected;
			needsSave = true;
		}
		
		private function onMMOLMultiplierChanged(e:Event):void
		{
			mmolMultiplierEnabled = mmolMultiplierCheck.isSelected;
			needsSave = true;
		}
		
		override protected function onStarlingResize(event:ResizeEvent):void 
		{
			width = Constants.stageWidth - (2 * BaseMaterialDeepGreyAmberMobileTheme.defaultPanelPadding);
			
			if (mmolMultiplierLabel != null)
				mmolMultiplierLabel.width = width - 20;
			
			setupRenderFactory();
		}
		
		/**
		 * Utility
		 */
		override public function dispose():void
		{
			if(appBadgeToggle != null)
			{
				appBadgeToggle.removeEventListener(Event.CHANGE, onAppBadgeChanged);
				appBadgeToggle.dispose();
				appBadgeToggle = null;
			}
			
			if(mmolMultiplierCheck != null)
			{
				mmolMultiplierCheck.removeEventListener(Event.CHANGE, onMMOLMultiplierChanged);
				mmolMultiplierCheck.dispose();
				mmolMultiplierCheck = null;
			}
			
			if(mmolMultiplierLabel != null)
			{
				mmolMultiplierLabel.dispose();
				mmolMultiplierLabel = null;
			}
			
			super.dispose();
		}
	}
}