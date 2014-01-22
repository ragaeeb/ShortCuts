import bb.cascades 1.2
import bb.device 1.0
import bb.multimedia 1.0
import com.canadainc.data 1.0

TabbedPane
{
    id: root
    activeTab: gestureTab
    showTabsOnActionBar: true
    
    attachedObjects: [
        MediaKeyWatcher
        {
            key: MediaKey.PlayPause
            
            onShortPress: {
                if ( persist.getValueFor("allowFocus") == 1 ) {
                    app.focus();
                }
            }
        },
        
        HardwareInfo {
            id: hw
        }
    ]
    
    Menu.definition: CanadaIncMenu
    {
        allowDonations: true
        projectName: "short-cuts"
        bbWorldID: "24609872"
    }
    
    Tab
    {
        id: gestureTab
        title: qsTr("Main") + Retranslate.onLanguageChanged
        description: qsTr("Play") + Retranslate.onLanguageChanged
        imageSource: "images/ic_gesture.png"
        delegateActivationPolicy: TabDelegateActivationPolicy.ActivateImmediately
        
        delegate: Delegate {
            source: "GestureTab.qml"
        }
    }
    
    Tab {
        id: edit
        title: qsTr("Edit") + Retranslate.onLanguageChanged
        description: qsTr("Delete Saved Shortcuts") + Retranslate.onLanguageChanged
        imageSource: "images/ic_edit.png"
        delegateActivationPolicy: TabDelegateActivationPolicy.ActivateWhenSelected
        
        delegate: Delegate {
            source: "EditTab.qml"
        }
        
        function onDataLoaded(id, data)
        {
            if (id == QueryId.GetAll) {
                unreadContentCount = data.length;
            }
        }
        
        onCreationCompleted: {
            sql.dataLoaded.connect(onDataLoaded);
        }
    }
    
    function onFullScreen()
    {
        if ( !hw.isPhysicalKeyboardDevice && persist.getValueFor("showVKB") == 1 && activeTab == gestureTab ) {
            vkb.show();
        }
    }
    
    onCreationCompleted: {
        Application.fullscreen.connect(onFullScreen);
    }
}