import bb.cascades 1.0
import bb.cascades.pickers 1.0

BaseRegisterPage
{
    contentContainer: Container
    {
        topPadding: 20;
        
        onCreationCompleted: {
            pcps.open()
        }
        
	    ImageView {
	        id: avatar
	        topMargin: 0
	        leftMargin: 0
	        rightMargin: 0
	        bottomMargin: 0
	        scalingMethod: ScalingMethod.AspectFit
	
	        horizontalAlignment: HorizontalAlignment.Center
	        verticalAlignment: VerticalAlignment.Top
	    }
        
        Label {
            id: contactName
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.fontSize: FontSize.XXSmall
        }
        
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            topMargin: 20

            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        title: ListItemData.number
                        description: ListItemData.name
                    }
                }
            ]
            
            dataModel: ArrayDataModel {
                id: theDataModel
            }
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            
            onTriggered: {
                app.registerPhone( sequence, dataModel.data(indexPath).number )
            }
        }
    }
    
    attachedObjects: [
        PimContactPickerSheet {
            id: pcps
            
            onContactSelected: {
                contactName.text = name
                avatar.imageSource = avatarPath
                
                theDataModel.clear()
                var result = pcps.getPhoneNumbers()
                
                for (var i = 0; i < result.length; i++) {
                    theDataModel.append(result[i])
                }
            }
        }
    ]
}
