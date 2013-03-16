import bb.cascades 1.0

BaseRegisterPage
{
    contentContainer: Container
    {
        topPadding: 20
        
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        title: ListItemData.name
                        description: ListItemData.app
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
                theDataModel.append( {name: "About", app: "Settings", uri: "settings://about"} );
                theDataModel.append( {name: "Accessibility", app: "Settings", uri: "settings://accessibility"} );
                theDataModel.append( {name: "Child Protection", app: "Settings", uri: "settings://childprotection"} );
                theDataModel.append( {name: "Date & Time", app: "Settings", uri: "settings://datetime"} );
                theDataModel.append( {name: "Development Mode", app: "Settings", uri: "settings://devmode"} );
                theDataModel.append( {name: "Display", app: "Settings", uri: "settings://display"} );
                theDataModel.append( {name: "Language & Input", app: "Settings", uri: "settings://language"} );
                theDataModel.append( {name: "Mobile Network", app: "Settings", uri: "settings://radio"} );
                theDataModel.append( {name: "Network Connections", app: "Settings", uri: "settings://networkconnections"} );
                theDataModel.append( {name: "NFC", app: "Settings", uri: "settings://nfc"} );
                theDataModel.append( {name: "Mobile Hotspot", app: "Settings", uri: "settings://mhs"} );
	            theDataModel.append( {name: "Notification", app: "Settings", uri: "settings://notification"} );
                theDataModel.append( {name: "Password", app: "Settings", uri: "settings://password"} );
                theDataModel.append( {name: "Security", app: "Settings", uri: "settings://security"} );
                theDataModel.append( {name: "Sharing", app: "Settings", uri: "settings://sharing"} );
                theDataModel.append( {name: "Sound", app: "Settings", uri: "settings://sound"} );
                theDataModel.append( {name: "Storage & Access", app: "Settings", uri: "settings://storage"} );
                theDataModel.append( {name: "Tethering", app: "Settings", uri: "settings://tethering"} );
                theDataModel.append( {name: "VPN", app: "Settings", uri: "settings://vpn"} );
                theDataModel.append( {name: "Voice Control", app: "Settings", uri: "settings://voice"} );
            }
            
            onTriggered: {
                app.registerApp( sequence, "sys.settings.target", dataModel.data(indexPath).uri, "settings/view" )
            }
        }
    }
}