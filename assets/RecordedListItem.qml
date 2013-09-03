import bb.cascades 1.0

StandardListItem
{
    id: sli
    
    contextActions: [
        ActionSet {
            title: sli.title
            subtitle: sli.description
            
            DeleteActionItem {
                title: qsTr("Remove") + Retranslate.onLanguageChanged
                imageSource: "images/ic_delete_shortcut.png"
                
                onTriggered: {
                    sli.ListItem.view.removeRecent(ListItemData);
                }
            }
        }
    ]
}