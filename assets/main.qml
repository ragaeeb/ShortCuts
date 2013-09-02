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
                    var value = String.fromCharCode(event.key);
                    gestureContainer.recordGesture( "%1".arg(value) );
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
            layout: DockLayout {}
            
            onCreationCompleted: {
                if ( persist.getValueFor("tutorialCount") < 1 ) {
                    persist.showToast( qsTr("In this pane, perform all the gestures you want to process!"), qsTr("OK") );
                    persist.saveValueFor("tutorialCount", 1);
                }
            }
	        
	        GestureContainer
	        {
	            id: gestureContainer
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	            
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
	            
	            onGestureAdded: {
                    currentKey.text = value;
                    fadeInOut.play();
                }
		    }
	        
            Label {
                id: currentKey
                textStyle.fontSize: FontSize.XXLarge
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                opacity: 0
                
                animations: [
                    ParallelAnimation
                    {
                        id: fadeInOut
                        
                        SequentialAnimation {
                            FadeTransition {
                                fromOpacity: 0
                                toOpacity: 1
                                duration: 250
                            }
                            
                            FadeTransition {
                                fromOpacity: 1
                                toOpacity: 0
                                duration: 250
                            }
                        }
                        
                        ScaleTransition {
                            fromX: 1
                            toX: 1.75
                            fromY: 1
                            toY: 1.75
                        }
                        
                        onEnded: {
                            currentKey.scaleX = currentKey.scaleY = 1;
                        }
                    }
                ]
            }
        }
    }
}