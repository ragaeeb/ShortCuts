import bb.cascades 1.0

Page
{
    property string sequence
    
    Container
    {
        topPadding: 10
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Label {
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.fontSize: FontSize.XXSmall
            multiline: true
            text: sequence
        }
        
        Label {
            topMargin: 10
            multiline: true
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            text: qsTr("What should this gesture do?") + Retranslate.onLanguageChanged
        }
        
        Divider {
            topMargin: 0; bottomMargin: 0
        }

        ListView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            dataModel: ArrayDataModel {
                id: theDataModel
            }

            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        title: ListItemData.name
                        imageSource: ListItemData.imageSource
                        description: ListItemData.description
                    }
                }
            ]
            
            onCreationCompleted: {
                theDataModel.append( { name: qsTr("Browse"), source: "RegisterSitePage.qml", imageSource: "images/ic_open_link.png", description: qsTr("Website") } );
                theDataModel.append( { name: qsTr("Contact"), source: "RegisterCallPage.qml", imageSource: "images/ic_user.png" , description: qsTr("Email, SMS, & Phone")} );
                theDataModel.append( { name: qsTr("Launch Settings"), source: "RegisterSettingsPage.qml", imageSource: "images/ic_settings.png", description: qsTr("BB10 Settings") } );
                theDataModel.append( { name: qsTr("Open"), source: "RegisterFilePage.qml", imageSource: "images/ic_open_file.png", description: qsTr("Open File") } );
            }
            
            onTriggered: {
				pageDefinition.source = dataModel.data(indexPath).source
				var page = pageDefinition.createObject()
				page.sequence = sequence
                
				navPane.push(page)
            }
            
            attachedObjects: [
                ComponentDefinition {
                    id: pageDefinition
                }
            ]
        }
    }
}