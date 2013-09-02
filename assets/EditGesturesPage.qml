import bb.cascades 1.0
import bb.system 1.0

Page
{
    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
    actions: [
        DeleteActionItem {
            id: clearAllAction
            title: qsTr("Delete All") + Retranslate.onLanguageChanged
            enabled: app.numShortcuts > 0

            onTriggered: {
            	prompt.show()
            }

            attachedObjects: [
                SystemDialog {
                    id: prompt
                    title: qsTr("Confirm") + Retranslate.onLanguageChanged
                    body: qsTr("Are you sure you want to delete all the gestures?") + Retranslate.onLanguageChanged
                    confirmButton.label: qsTr("Yes") + Retranslate.onLanguageChanged
                    cancelButton.label: qsTr("No") + Retranslate.onLanguageChanged

                    onFinished: {
                        if (result == SystemUiResult.ConfirmButtonSelection) {
                            app.clearAllShortcuts()
                            theDataModel.clear()
                        }
                    }
                }
            ]
        }
    ]
    
    function onNumShortcutsChanged() {
        if (app && app.numShortcuts == 0) {
            properties.navPane.pop()
        }
    }
    
    onCreationCompleted: {
        app.numShortcutsChanged.connect(onNumShortcutsChanged);
    }
    
    Container
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            function performDelete(ListItem) {
                var removed = app.removeShortcut(ListItem.data.sequence)

                if (removed) {
                    theDataModel.removeAt(ListItem.indexPath)
                }
            }

            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        id: sli
                        
                        imageSource: {
                            if (ListItemData.type == "phone") {
                                return "file:///usr/share/icons/ic_phone.png"
                            } else if (ListItemData.type == "uri") {
                                return "images/ic_open_link.png"
                            } else if (ListItemData.type == "file") {
                                return "images/action_openFile.png"
                            } else {
                                return "file:///usr/share/icons/bb_action_open.png"
                            }
                        }
                        
                        title: {
                            if (ListItemData.type == "phone") {
                                return ListItemData.number
                            } else if (ListItemData.type == "file") {
                                return ListItemData.uri.substring( ListItemData.uri.lastIndexOf("/")+1 )
                            } else {
                                return ListItemData.uri
                            }
                        }
                        
                        description: ListItemData.sequence
                        
                        contextActions: [
                            ActionSet {
                                title: sli.title
                                subtitle: sli.description
                                
                                DeleteActionItem {
                                    onTriggered: {
                                        sli.ListItem.view.performDelete(sli.ListItem)
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
            
            dataModel: ArrayDataModel {
                id: theDataModel
            }
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            
            onCreationCompleted: {
                var shortcuts = app.getAllShortcuts()
                theDataModel.append(shortcuts)
            }
        }
    }
}