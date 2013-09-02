import bb.cascades 1.0
import bb.multimedia 1.0

NavigationPane
{
    id: navigationPane
    
    attachedObjects: [
        ComponentDefinition {
            id: definition
        },
        
        MediaKeyWatcher
        {
            key: MediaKey.PlayPause
            
            onShortPress: {
                app.focus();
            }
        }
    ]

    Menu.definition: CanadaIncMenu {
        projectName: "short-cuts"
    }

    onPopTransitionEnded: {
        page.destroy();
    }
    
    Page
    {
        keyListeners: [
            KeyListener {
                onKeyReleased: {
                    gestureContainer.recordGesture( "%1".arg( String.fromCharCode(event.key) ) )
                }
            }
        ]
        
        actions: [
            ActionItem {
                title: qsTr("Edit") + Retranslate.onLanguageChanged
                imageSource: "images/ic_edit.png"
                enabled: app.numShortcuts > 0
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered:
                {
                    definition.source = "EditGesturesPage.qml"
                    var page = definition.createObject()
                    navigationPane.push(page);
                }
            }
        ]
        
        Container
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