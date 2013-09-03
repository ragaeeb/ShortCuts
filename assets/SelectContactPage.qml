import bb.cascades 1.0
import bb.cascades.pickers 1.0
import com.canadainc.data 1.0

Page
{
    property string sequence
    
    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
    onCreationCompleted: {
        pcps.open();
    }
    
    ControlDelegate
    {
        id: containerDelegate
        delegateActive: false
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        sourceComponent: ComponentDefinition
        {
            Container
            {
                property alias avatar: photo
                property alias contactName: nameLabel
                property alias model: theDataModel
                
                topPadding: 20; leftPadding: 20; rightPadding: 20
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                ImageView {
                    id: photo
                    topMargin: 0
                    leftMargin: 0
                    rightMargin: 0
                    bottomMargin: 0
                    
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Top
                    preferredHeight: 120; preferredWidth: 120;
                }
                
                Label {
                    id: nameLabel
                    horizontalAlignment: HorizontalAlignment.Fill
                    textStyle.textAlign: TextAlign.Center
                }
                
                Divider {
                    topMargin: 0; bottomMargin: 0
                }
                
                ListView {
                    id: listView
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    
                    function itemType(data, indexPath) {
                        return data.type;
                    }
                    
                    listItemComponents: [
                        ListItemComponent {
                            type: "phone"
                            
                            StandardListItem {
                                title: ListItemData.value
                                description: qsTr("Call %1").arg(ListItemData.name)
                                imageSource: "images/ic_phone.png"
                            }
                        },
                        
                        ListItemComponent {
                            type: "sms"
                            
                            StandardListItem {
                                title: ListItemData.value
                                description: qsTr("SMS %1").arg(ListItemData.name)
                                imageSource: "images/ic_sms.png"
                            }
                        },
                        
                        ListItemComponent {
                            type: "email"
                            
                            StandardListItem {
                                title: ListItemData.value
                                description: ListItemData.name
                                imageSource: "images/ic_email.png"
                            }
                        }
                    ]
                    
                    dataModel: ArrayDataModel {
                        id: theDataModel
                    }
                    
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    
                    onTriggered:
                    {
                        var data = theDataModel.data(indexPath);
                        
                        app.registerShortcut(sequence, data.type, data.value);
                        properties.navPane.pop();
                        properties.navPane.pop();
                    }
                }
            }
        }
    }
    
    attachedObjects: [
        PimContactPickerSheet {
            id: pcps
            filterMobile: true
            
            onContactSelected: {
                containerDelegate.delegateActive = true;
                containerDelegate.control.contactName.text = result.displayName;
                
                var imageSource = "images/ic_user.png";
                var smallPhotoPath = result.smallPhotoPath;
                
                if (smallPhotoPath) {
                    if (smallPhotoPath.indexOf("file://") == -1) { // 10.1+
                        imageSource = "file://"+smallPhotoPath;
                    } else {
                        imageSource = smallPhotoPath;
                    }
                }
                
                containerDelegate.control.avatar.imageSource = imageSource;
                
                containerDelegate.control.model.clear();
                containerDelegate.control.model.append(result.mediums);
            }
            
            onCanceled: {
                properties.navPane.pop();
            }
        }
    ]
}