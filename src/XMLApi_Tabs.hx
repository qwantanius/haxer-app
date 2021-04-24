import Sys;
import Xml;
import feathers.data.*;

class XMLApi_Tabs
{

    private var pathToXMLConfig:String;
    private var XMLString:String;
    private var XMLContent:Xml;
    private var TAB_TAG_NAME:String;
    private var tabTitles:Array<{text:String}>;
    private var allLabels:Array<{tabid:String,text:String}>;
    private var allButtons:Array<{
                tabid:String,
                text: String,
                pathToIcon:String,
                positionX: String,
                positionY: String
    }>;


    public function new(path:String)
    {

        this.tabTitles = [];
        this.TAB_TAG_NAME = "tab";
        this.pathToXMLConfig = path;
        this.XMLContent = Xml.parse(this.get_XMLContentString());
        this.parseXMLConfig();
    }

    
    private function parseXMLConfig():Void
    {
        for(tab in this.XMLContent.elementsNamed(this.TAB_TAG_NAME))
        {
            this.tabTitles.push({
                text: Std.string(tab.firstChild().nodeValue)
            });
        }
    }

	public function get_XMLContentString():String
    {
		this.XMLString = sys.io.File.getContent(this.pathToXMLConfig);
		return Std.string(this.XMLString);
	}

    public function get_tabTitles():Array<{text:String}>
    {
        return this.tabTitles;
    }

    public function get_allButtons():Array<{
                tabid:String,
                text: String,
                pathToIcon:String,
                positionX: String,
                positionY: String
    }>{
        this.allButtons = [];
        for(buttonOfTabPage in this.XMLContent.elementsNamed("item-button"))
        {
            this.allButtons.push({
                tabid: buttonOfTabPage.get("tabid"),
                text: buttonOfTabPage.firstChild().nodeValue,
                pathToIcon: buttonOfTabPage.get("icon"),
                positionX: buttonOfTabPage.get("pos-x"),
                positionY: buttonOfTabPage.get("pos-y"),
            });
        }
        return this.allButtons;
    }

    public function get_allLabels():Array<{tabid:String,text:String}>
    {       
        this.allLabels = [];
        for(labelOfTab in this.XMLContent.elementsNamed("label-text"))
        {
            this.allLabels.push({
                tabid:labelOfTab.get("tabid"),
                text: labelOfTab.firstChild().nodeValue,
            });
        }
        return this.allLabels;
    }
}

