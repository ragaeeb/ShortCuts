import bb.cascades 1.0

NavigationPane
{
    id: navigationPane
    property string lastSequence
    
    attachedObjects: [
        ComponentDefinition {
            id: definition
        }
    ]
    
    onPopTransitionEnded: {
        page.destroy();
    }
    
    
    function onDataLoaded(id, data)
    {
        if (id == 85 && data.length == 0)
        {
            definition.source = "GestureReactionPage.qml";
            var page = definition.createObject();
            page.sequence = lastSequence;
            navigationPane.push(page);
        }
    }
    
    onCreationCompleted: {
        sql.dataLoaded.connect(onDataLoaded);
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
        
        Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            topPadding: 20
            layout: DockLayout {}
            
            onCreationCompleted: {
                if ( persist.getValueFor("gestureTutorialCount") < 1 ) {
                    persist.showToast( qsTr("In this pane, perform all the gestures you want to process!"), qsTr("OK") );
                    persist.saveValueFor("gestureTutorialCount", 1);
                }
            }
            
            RecordedGesturesLabel {
                id: instructions
                verticalAlignment: VerticalAlignment.Top
            }
            
            GestureContainer
            {
                id: gestureContainer
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                onSequenceCompleted: {
                    lastSequence = sequence.join(", ");
                    sql.query = "SELECT * from gestures WHERE sequence='%1'".arg(lastSequence);
                    sql.load(85);
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