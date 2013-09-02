import bb.cascades 1.0

Page
{
    property string sequence
    
    Container
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Label {
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.fontSize: FontSize.XXSmall
            multiline: true
            text: sequence
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
                    }
                }
            ]
            
            onCreationCompleted: {
                theDataModel.append( { name: qsTr("Browse"), source: "RegisterSitePage.qml" } )
                theDataModel.append( { name: qsTr("Call"), source: "RegisterCallPage.qml" } )
                theDataModel.append( { name: qsTr("Launch"), source: "RegisterAppPage.qml" } )
                theDataModel.append( { name: qsTr("Open"), source: "RegisterFilePage.qml" } )
            }
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
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