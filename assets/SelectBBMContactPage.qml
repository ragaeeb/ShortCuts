import bb.cascades 1.0
import com.canadainc.data 1.0

Page
{
    property string sequence
    
    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
    titleBar: TitleBar {
        title: qsTr("BBM") + Retranslate.onLanguageChanged
    }
    
    actions: [
        ActionItem {
            id: saveAction
            title: qsTr("Save") + Retranslate.onLanguageChanged
            imageSource: "images/ic_save.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                contactPin.validator.validate();
                
                if (contactPin.validator.valid)
                {
                    app.registerShortcut(sequence, shortcutType.selectedValue, contactPin.text);
                    properties.navPane.pop();
                    properties.navPane.pop();
                }
            }
            
            enabled: contactPin.text.length == 8
        },
        
        ActionItem {
            title: qsTr("Launch BBM") + Retranslate.onLanguageChanged
            imageSource: "file:///usr/share/icons/ic_start_bbm_chat.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                invoker.launchBBM();
            }
            
            attachedObjects: [
	            InvocationUtils {
	                id: invoker
	            }
            ]
        }
    ]
    
    ScrollView
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
	    Container
	    {
	        topPadding: 20; leftPadding: 20; rightPadding: 20
	        
		    ImageView {
		        id: avatar
		        topMargin: 0
		        leftMargin: 0
		        rightMargin: 0
		        bottomMargin: 0
	            imageSource: "file:///usr/share/icons/ic_start_bbm_chat.png"
		
		        horizontalAlignment: HorizontalAlignment.Center
		        verticalAlignment: VerticalAlignment.Top
		        preferredHeight: 120; preferredWidth: 120;
	        }
		    
		    DropDown {
		        id: shortcutType
		        horizontalAlignment: HorizontalAlignment.Fill
		        title: qsTr("Launch") + Retranslate.onLanguageChanged
		        
                Option {
                    imageSource: "images/ic_chat.png"
                    text: qsTr("Chat") + Retranslate.onLanguageChanged
                    value: "bbm_chat"
                    selected: true
                }
                
                Option {
                    imageSource: "images/ic_bbm_voice.png"
                    text: qsTr("Voice Call") + Retranslate.onLanguageChanged
                    value: "bbm_voice"
                }
                
                Option {
                    imageSource: "images/ic_bbm_video.png"
                    text: qsTr("Video Call") + Retranslate.onLanguageChanged
                    value: "bbm_video"
                }
          	}
		    
		    Label {
	            id: contactName
	            horizontalAlignment: HorizontalAlignment.Fill
	        }
	        
	        TextField {
	            id: contactPin
	            horizontalAlignment: HorizontalAlignment.Fill
	            hintText: qsTr("Enter BBM PIN") + Retranslate.onLanguageChanged
	            
                validator: Validator
                {
                    errorMessage: qsTr("Invalid PIN") + Retranslate.onLanguageChanged
                    
                    onValidate: { 
                    	var regex=/^[0-9A-F]+$/
                        valid = regex.test(contactPin.text) && contactPin.text.length == 8;
                    }
                }
                
                input {
                    submitKey: SubmitKey.Submit
                    
                    onSubmitted: {
                        saveAction.triggered();
                    }
                }
	        }
	        
	        Label {
	            horizontalAlignment: HorizontalAlignment.Fill
	            textStyle.textAlign: TextAlign.Center
	            text: qsTr("Open BBM, tap on the contact you want to add a shortcut for, tap on the profile banner at the top, choose 'Show', and copy the PIN and paste it above.")
	            multiline: true
	            textStyle.fontSize: FontSize.XSmall
	        }
	        
	        Container
	        {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                ImageView {
                    imageSource: "images/bbm/0.png"
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Center
                }
                
                ImageView {
                    imageSource: "images/bbm/1.png"
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
        }
    }
}