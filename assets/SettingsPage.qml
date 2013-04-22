import bb.cascades 1.0

BasePage {
    contentContainer: Container
    {
        leftPadding: 20; topPadding: 20; rightPadding: 20; bottomPadding: 20
        
        SettingPair {
            title: qsTr("Animations")
        	toggle.checked: persist.getValueFor("animations") == 1
    
            toggle.onCheckedChanged: {
        		persist.saveValueFor("animations", checked ? 1 : 0)
        		
        		if (checked) {
        		    infoText.text = qsTr("Controls will be animated whenever they are loaded. Note that this may affect shortcut interpretation. If your gestures are not always recognized properly, turn this off.")
        		} else {
        		    infoText.text = qsTr("Controls will be snapped into position without animations.")
        		}
            }
        }
        
		Container
		{
		    topMargin: 20
		    
		    layout: StackLayout {
		        orientation: LayoutOrientation.LeftToRight
		    }
		    
		    Label {
		        text: qsTr("Processing Delay")
		        
		        layoutProperties: StackLayoutProperties {
		            spaceQuota: 1
		        }
		    }
		    
		    Slider {
		        id: slider
		        horizontalAlignment: HorizontalAlignment.Right
		        preferredWidth: 225
		        fromValue: 900
		        toValue: 3000
		        value: persist.getValueFor("delay")
		        
		        onValueChanged: {
		            persist.saveValueFor("delay", value)
		            infoText.text = qsTr("Gestures will be interpreted after %1 seconds. Note that if this is too short, and you have some complex gestures, it might make it harder for the system to always interpret them. If your gestures are not always recognized properly, increase this value.").arg(value/1000)
		        }
		    }
		    
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
		}
        
        Label {
            id: infoText
            multiline: true
            textStyle.fontSize: FontSize.XXSmall
            textStyle.textAlign: TextAlign.Center
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
}