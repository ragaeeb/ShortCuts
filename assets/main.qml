import bb.cascades 1.0
import bb.multimedia 1.0

TabbedPane
{
    activeTab: gestureTab
    showTabsOnActionBar: true
    
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
    
    function lazyLoad(actualSource, tab) {
        definition.source = actualSource;
        
        var actual = definition.createObject();
        tab.content = actual;
        
        return actual;
    }
    
    Tab
    {
        id: gestureTab
        title: qsTr("Main") + Retranslate.onLanguageChanged
        description: qsTr("Play") + Retranslate.onLanguageChanged
        imageSource: "images/ic_gesture.png"
        
        GestureTab {}
    }
    
    Tab {
        id: edit
        title: qsTr("Edit") + Retranslate.onLanguageChanged
        description: qsTr("Delete Saved Shortcuts") + Retranslate.onLanguageChanged
        imageSource: "images/ic_edit.png"
        
        onTriggered: {
            if (! content) {
                lazyLoad("EditTab.qml", edit);
            }
        }
        
        function onDataLoaded(id, data)
        {
            if (id == 2) {
                unreadContentCount = data.length;
            }
        }
        
        onCreationCompleted: {
            sql.dataLoaded.connect(onDataLoaded);
        }
    }
}