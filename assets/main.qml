import bb.cascades 1.0
import CustomComponent 1.0

NavigationPane
{
    id: navigationPane

    property SettingsPage settingsPage
    property HelpPage helpPage

    Menu.definition: MenuDefinition
    {
        settingsAction: SettingsActionItem
        {
            onTriggered:
            {
                if (!settingsPage) {
                    settingsPage = settingsPageDefinition.createObject()
                }
                
                navigationPane.push(settingsPage);
            }
        }
        
        actions: [
            ActionItem {
                title: qsTr("Edit")
                imageSource: "asset:///images/ic_edit.png"
                enabled: navigationPane.top == page
                
                onTriggered:
                {
                    var page = editPageDefinition.createObject()
                    navigationPane.push(page);
                }
            }
        ]

        helpAction: HelpActionItem
        {
            onTriggered:
            {
                if (!helpPage) {
                    helpPage = helpPageDefinition.createObject();
                }

                navigationPane.push(helpPage);
            }
        }
    }

    onPopTransitionEnded: {
        page.destroy();
    }
    
    attachedObjects: [
		
        ComponentDefinition {
            id: settingsPageDefinition
            source: "SettingsPage.qml"
        },
        
        ComponentDefinition {
            id: helpPageDefinition
            source: "HelpPage.qml"
        },
        
        ComponentDefinition {
            id: editPageDefinition
            source: "EditGesturesPage.qml"
        }
    ]

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
	            property variant array: []
	            
	            id: gestureContainer
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	            
	            layoutProperties: StackLayoutProperties {
	                spaceQuota: 1
	            }
	            
		        function recordGesture(value)
		        {
		            timer.start()
		            
		            var copy = array
		            copy.push(value)
		            array = copy
		        }
		        
		        onSwipedDown: {
		            recordGesture("Down")
		        }
		        
		        onSwipedUp: {
		            recordGesture("Up")
		        }
		        
		        onSwipedLeft: {
		            recordGesture("Left")
		        }
		        
		        onSwipedRight: {
		            recordGesture("Right")
		        }
		        
		        onSwipedDownRight: {
		            recordGesture("DownRight")
		        }
	
		        onSwipedDownLeft: {
		            recordGesture("DownLeft")
		        }
		        
		        onSwipedUpRight: {
		            recordGesture("UpRight")
		        }
		        
		        onSwipedUpLeft: {
		            recordGesture("UpLeft")
		        }
		        
		        gestureHandlers: [
		            TapHandler {
		                onTapped: {
		                    gestureContainer.recordGesture("Tap")
		                }
	                },
	                
	                DoubleTapHandler {
	                    onDoubleTapped: {
	                        gestureContainer.recordGesture("DoubleTap")
	                    }
	                },
	                
	                PinchHandler {
	                    onPinchEnded: {
	                        //console.log(event.pinchRatio, event.rotation, event.distance)
	                        gestureContainer.recordGesture("Pinch")
	                    }
	                }
		        ]
		        
		        attachedObjects: [
	                QTimer {
	                    id: timer
	                    singleShot: true
	                    interval: app.getValueFor("delay")
	                    
	                    onTimeout: {
	                        var result = app.process(gestureContainer.array)
	                        var sequence = app.render(gestureContainer.array)
	                        var array = []
	                        gestureContainer.array = array
	                        
	                        if (!result) {
	                            var page = grpDefinition.createObject()
	                            page.sequence = sequence
	                            navigationPane.push(page)
	                        }
	                    }
	                },
	                
			        ComponentDefinition {
			            id: grpDefinition
			            source: "GestureReactionPage.qml"
			        }
		        ]
		    }
        }
    }
}