import bb.cascades 1.0
import CustomComponent 1.0

NavigationPane
{
    id: navigationPane

    attachedObjects: [
        ComponentDefinition {
            id: definition
        }
    ]

    Menu.definition: MenuDefinition
    {
        settingsAction: SettingsActionItem
        {
            property Page settingsPage
            
            onTriggered:
            {
                if (!settingsPage) {
                    definition.source = "SettingsPage.qml"
                    settingsPage = definition.createObject()
                }
                
                navigationPane.push(settingsPage);
            }
        }

        helpAction: HelpActionItem
        {
            property Page helpPage
            
            onTriggered:
            {
                if (!helpPage) {
                    definition.source = "HelpPage.qml"
                    helpPage = definition.createObject();
                }

                navigationPane.push(helpPage);
            }
        }
        
        actions: [
            ActionItem {
                title: qsTr("Edit")
                imageSource: "file:///usr/share/icons/ic_edit.png"
                enabled: navigationPane.top == page
                
                onTriggered:
                {
                    definition.source = "EditGesturesPage.qml"
                    var page = definition.createObject()
                    navigationPane.push(page);
                }
            }
        ]
    }

    onPopTransitionEnded: {
        page.destroy();
    }
    
    BasePage
    {
        id: page
        titleContainer.enabled: false

        keyListeners: [
            KeyListener {
                onKeyReleased: {
                    gestureContainer.recordGesture( "%1".arg( String.fromCharCode(event.key) ) )
                }
            }
        ]
        
        contentContainer: Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            topPadding: 20
            
            Label
	        {
	            id: label
	            text: qsTr("In this pane perform all the gestures you want to register and/or process.") + Retranslate.onLanguageChanged
	            multiline: true
	            textStyle.fontSize: FontSize.XXSmall
	            horizontalAlignment: HorizontalAlignment.Center
	            verticalAlignment: VerticalAlignment.Center
	            textStyle.textAlign: TextAlign.Center
	            enabled: false
	        }
	        
	        GestureContainer
	        {
	            id: gestureContainer
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	            
	            layoutProperties: StackLayoutProperties {
	                spaceQuota: 1
	            }
	            
	            onSequenceCompleted: {
                    var result = app.process(sequence)
                    
                    if (!result) {
                        var sequenceString = app.render(sequence)
                        
                        definition.source = "GestureReactionPage.qml"
                        var page = definition.createObject()
                        page.sequence = sequenceString
                        navigationPane.push(page)
                    }
	            }
		    }
        }
    }
}