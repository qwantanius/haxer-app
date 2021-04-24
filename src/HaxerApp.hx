import Sys;
import sys.FileSystem;
import Xml;
import XMLApi_Tabs;
import feathers.controls.*;
import feathers.data.*;
import feathers.utils.*;
import feathers.layout.*;
import feathers.controls.dataRenderers.*;
import openfl.Assets;
import motion.Actuate;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventType;
import openfl.events.MouseEvent;




// возможность парсить данные с текстового файла
// ограничить размер экрана
// чистка дубликатов
// билд под винду!!!! по возможнсти проектный конфиг флэшадев
class HaxerApp extends Application 
{

	private var currentTab:String;
	private var tabs:TabBar;
	private var buttons:Array<Button>;
	private var lastClickedButton:Button;
	private var xmlAPI:XMLApi_Tabs;
	private var allLabels:Array<{tabid:String,label:Label}>;

	public function new() 
	{

		super();
		this.tabs = initTabs();	

	}

	
	public function initTabs():TabBar
	{
		var tabs = new TabBar();
		var xmlTabsAPI = new XMLApi_Tabs(FileSystem.absolutePath("tabsconfig.xml"));
		tabs.dataProvider = new ArrayCollection(xmlTabsAPI.get_tabTitles());
		this.buttons = [];
		this.allLabels = [];
		for(labelXML in xmlTabsAPI.get_allLabels())
		{
			var labelUI = new Label();
			labelUI.text = labelXML.text;
			labelUI.x = 0;
			labelUI.y = 50;
			this.allLabels.push({
				tabid:labelXML.tabid,
				label:labelUI
			});
		}
		if(currentTab == null)
		{
			this.addChild(this.allLabels[0].label);
		}


		for(btn in xmlTabsAPI.get_allButtons())
		{
			var button = new Button();
			button.text = btn.text;
			button.x = Std.parseFloat(btn.positionX);
			button.y = Std.parseFloat(btn.positionY);
			button.height = 50;
			button.width = 100;
			button.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):Void{
				this.lastClickedButton = button;
				Alert.show('Button \''+this.lastClickedButton.text+'\' on tab \''+this.currentTab+'\' clicked!',"Click event!",["OK"]);
			});
			this.buttons.push(button);
			this.addChild(button);
		}
		tabs.addEventListener(Event.CHANGE, function(event:Event):Void{
			currentTab = Std.string(tabs.selectedItem.text);
			var savedButtons:Array<Button> = [];
			var savedLabels:Array<Label> = [];
			for(labelXML in xmlTabsAPI.get_allLabels())
			{
				for(labelUI in this.allLabels)
				{
					if(labelUI.tabid == currentTab && labelXML.tabid == currentTab && labelUI.label.text == labelXML.text)
					{
						savedLabels.push(labelUI.label);
						for(labelUI in this.allLabels)
						{
							this.removeChild(labelUI.label);
						}
					}
				}
			}
			for(savedLabel in savedLabels)
			{
				this.addChild(savedLabel);
			}

			for(btn in xmlTabsAPI.get_allButtons())
			{
				for(button in this.buttons)
				{
					if(btn.tabid == currentTab && btn.text == button.text)
					{
						savedButtons.push(button);
						for(button in this.buttons)
						{
							this.removeChild(button);
						}
					} 
				}
			}
			for(savedButton in savedButtons)
			{
				this.addChild(savedButton);
			}
		});
		currentTab = Std.string(tabs.selectedItem.text);
		var savedButtons:Array<Button> = [];
		for(btn in xmlTabsAPI.get_allButtons())
		{
			for(button in this.buttons)
			{
				if(btn.tabid == currentTab && btn.text == button.text)
				{
					savedButtons.push(button);
					for(button in this.buttons)
					{
						this.removeChild(button);
					}
				} 
			}
		}
		for(savedButton in savedButtons)
		{
			this.addChild(savedButton);
		}
		this.addChild(tabs);
		tabs.itemToText = function(item:Dynamic):String {
    			return item.text;
		};
		return tabs;
		

	}



}