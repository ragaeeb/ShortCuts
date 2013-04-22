import bb.cascades 1.0
import bb.cascades.pickers 1.0

BaseRegisterPage
{
    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
    contentContainer: Container
    {
        topPadding: 20
        
        onCreationCompleted: {
            pcps.open()
            nameFadeIn.play()
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
	        
	        animations: [
	            RotateTransition {
	                id: rotate
	            	fromAngleZ: -180
	            	toAngleZ: 27
	            	duration: 500
                }
	        ]
	    }
        
        Label {
            id: contactName
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.fontSize: FontSize.XXSmall
            text: qsTr("Please select a contact...") + Retranslate.onLanguageChanged
            opacity: 0
            
            animations: [
                FadeTransition {
                    id: nameFadeIn
                    fromOpacity: 0
                    toOpacity: 1
                    duration: 1500
                }
            ]
        }
        
        Divider {
            id: separator
            visible: false
            bottomMargin: 0
        }
        
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

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
                separator.visible = true
                
                contactName.text = name

                if (avatarPath) {
                    if (avatarPath.indexOf("file://") == -1) {
                        avatar.imageSource = "file://" + avatarPath
                    } else {
                        avatar.imageSource = avatarPath
                    }
                } else {
                    avatar.imageSource = "file:///usr/share/icons/tmb_contact.png"
                }
                
                theDataModel.clear()
                theDataModel.append( pcps.getPhoneNumbers() )
                rotate.play()
                
                if ( theDataModel.size() == 1 ) {
                    listView.triggered([0], true)
                }
            }
            
            onCanceled: {
            	properties.navPane.pop()                
            }
        }
    ]
}