import bb.cascades 1.0
import bb.system 1.0
import com.canadainc.data 1.0

NavigationPane
{
    id: navigationPane
    
    onPopTransitionEnded: {
        page.destroy();
    }
    
    onCreationCompleted: {
        if ( persist.getValueFor("toggleTutorialCount") < 1 ) {
            persist.showToast( qsTr("Did you know that as long as you keep Sweep in the active tile frame or backgrounded, pressing the Play/Pause toggle button in between the Volume Up/Down button on the right-side of your BlackBerry 10 device brings the app back to the foreground? Try it!\n\nThis way you can quickly get access to your shortcuts with even fewer steps as long as you keep the app open!"), qsTr("OK") );
            persist.saveValueFor("toggleTutorialCount", 1);
        }
    }
    
    Page
    {
        titleBar: TitleBar {
            title: qsTr("Edit") + Retranslate.onLanguageChanged
        }
        
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        
        actions: [
            InvokeActionItem {
                id: home
                title: qsTr("Home Screen+") + Retranslate.onLanguageChanged
                imageSource: "images/ic_home.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                query {
                    mimeType: "text/html"
                    uri: "http://appworld.blackberry.com/webstore/content/24832896"
                    invokeActionId: "bb.action.OPEN"
                }
            },
            
            DeleteActionItem {
                title: qsTr("Clear All") + Retranslate.onLanguageChanged
                imageSource: "images/ic_delete_shortcut.png"
                
                onTriggered: {
                    prompt.show();
                }
                
                attachedObjects: [
                    SystemDialog {
                        id: prompt
                        title: qsTr("Confirmation") + Retranslate.onLanguageChanged
                        body: qsTr("Are you sure you want to clear all shortcuts?") + Retranslate.onLanguageChanged
                        confirmButton.label: qsTr("OK") + Retranslate.onLanguageChanged
                        cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged
                        
                        onFinished: {
                            if (result == SystemUiResult.ConfirmButtonSelection) {
                                app.clearAllShortcuts();
                                persist.showToast( qsTr("Cleared all shortcuts!") );
                            }
                        }
                    }
                ]
            }
        ]
        
        Container
        {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            topPadding: noElements.visible ? 20 : 0
            bottomPadding: topPadding; rightPadding: topPadding; leftPadding: topPadding
            
            Label {
                id: noElements
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                multiline: true
                text: qsTr("You have no shortcuts that you have registered. To create a new one, perform a gesture in the Main tab.") + Retranslate.onLanguageChanged
                visible: false
            }
            
            ListView
            {
                id: listView
                
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                
                dataModel: ArrayDataModel {
                    id: adm
                }
                
                function removeRecent(ListItemData) {
                    app.removeShortcut(ListItemData.sequence);
                }
                
                function itemType(data, indexPath) {
                    return data.type;
                }
                
                listItemComponents:
                [
                    ListItemComponent {
                        type: "bbm_video"
                        
                        RecordedListItem {
                            imageSource: "images/ic_bbm_video.png"
                            title: qsTr("BBM Video Call") + Retranslate.onLanguageChanged
                            description: ListItemData.uri
                        }
                    },
                    
                    ListItemComponent {
                        type: "bbm_voice"
                        
                        RecordedListItem {
                            imageSource: "images/ic_bbm_voice.png"
                            title: qsTr("BBM Voice Call") + Retranslate.onLanguageChanged
                            description: ListItemData.uri
                        }
                    },
                    
                    ListItemComponent {
                        type: "bbm_chat"
                        
                        RecordedListItem {
                            imageSource: "images/ic_chat.png"
                            title: qsTr("BBM Chat") + Retranslate.onLanguageChanged
                            description: ListItemData.uri
                        }
                    },
                    
                    ListItemComponent {
                        type: "setting"
                        
                        RecordedListItem {
                            imageSource: "images/ic_settings.png"
                            title: qsTr("BlackBerry 10 Setting") + Retranslate.onLanguageChanged
                            description: ListItemData.uri
                        }
                    },
                    
                    ListItemComponent {
                        type: "file"
                        
                        RecordedListItem {
                            imageSource: "images/ic_open_file.png"
                            title: qsTr("Open File") + Retranslate.onLanguageChanged
                            description: {
                                var lastSlash = ListItemData.uri.lastIndexOf("/");
                                var uri = ListItemData.uri.substring(lastSlash+1);
                                
                                return uri;
                            }
                        }
                    },
                    
                    ListItemComponent {
                        type: "url"
                        
                        RecordedListItem {
                            imageSource: "images/ic_open_link.png"
                            title: qsTr("Website") + Retranslate.onLanguageChanged
                            description: ListItemData.uri
                        }
                    },
                    
                    ListItemComponent {
                        type: "email"
                        
                        RecordedListItem {
                            imageSource: "images/ic_email.png"
                            title: qsTr("Email") + Retranslate.onLanguageChanged
                            description: ListItemData.uri
                        }
                    },
                    
                    ListItemComponent {
                        type: "sms"
                        
                        RecordedListItem {
                            imageSource: "images/ic_sms.png"
                            title: qsTr("SMS") + Retranslate.onLanguageChanged
                            description: ListItemData.uri
                        }
                    },
                    
                    ListItemComponent
                    {
                        type: "phone"
                        
                        RecordedListItem {
                            id: sli
                            imageSource: "images/ic_phone.png";
                            title: qsTr("Phone") + Retranslate.onLanguageChanged
                            description: ListItemData.uri;
                        }
                    }
                ]
                
                function onDataLoaded(id, data)
                {
                    if (id == QueryId.GetAll) {
                        adm.clear();
                        adm.append(data);
                        
                        noElements.visible = data.length == 0;
                    }
                }
                
                onCreationCompleted: {
                    sql.dataLoaded.connect(onDataLoaded);
                    app.requestAllShortcuts();
                }
            }
        }
    }
}