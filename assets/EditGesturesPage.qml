import bb.cascades 1.0

BasePage
{
    actions: [
        DeleteActionItem {
            id: clearAllAction
            title: qsTr("Clear All")
            enabled: false
            
            onTriggered: {
                app.clearAllShortcuts()
                theDataModel.clear()
                emptyLabel = true
            }
        }
    ]
    
    contentContainer: Container
    {
        topPadding: 20
        
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Label {
            id: emptyLabel
            text: qsTr("No gestures have been registered.")
            textStyle.textAlign: TextAlign.Center
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Center
            multiline: true
            visible: false
        }
        
        ListView {
            property variant application
            
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            topMargin: 20

            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        id: sli
                        
                        imageSource: {
                            if (ListItemData.type == "phone") {
                                return "file:///usr/share/icons/ic_phone.png"
                            } else if (ListItemData.type == "uri") {
                                return "asset:///images/ic_open_link.png"
                            } else if (ListItemData.type == "file") {
                                return "asset:///images/action_openFile.png"
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
                                        var removed = sli.ListItem.view.application.removeShortcut(sli.ListItem.data.sequence)
                                        
                                        if (removed) {
                                            sli.ListItem.view.dataModel.removeAt(sli.ListItem.indexPath)
                                        }
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
            
            dataModel: ArrayDataModel {
                id: theDataModel
                
	            onItemRemoved: {
	                emptyLabel.visible = theDataModel.size() == 0
	                clearAllAction.enabled = theDataModel.size() > 0
	            }
            }
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            
            onCreationCompleted: {
                application = app
                var shortcuts = app.getAllShortcuts()
                theDataModel.append(shortcuts)
                
                emptyLabel.visible = shortcuts.length == 0
                clearAllAction.enabled = shortcuts.length > 0
            }
        }
    }
}