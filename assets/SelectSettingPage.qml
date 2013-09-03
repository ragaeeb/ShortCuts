import bb.cascades 1.0

Page
{
    property string sequence
    
    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
    Container
    {
        topPadding: 20;
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Label {
            id: contactName
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: SystemDefaults.TextStyles.TitleText
            text: qsTr("BB10 Settings")
        }

        Divider {
            id: separator
            topMargin: 0
            leftMargin: 0
            rightMargin: 0
            bottomMargin: 0
        }

        ListView {
            id: listView
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        title: ListItemData.name
                        description: ListItemData.description
                        imageSource: ListItemData.imageSource
                    }
                }
            ]
            
            dataModel: ArrayDataModel {
                id: theDataModel
            }
            
            onCreationCompleted: {
                theDataModel.append( {name: qsTr("About"), description: qsTr("OS, device name, hardware"), imageSource: "images/settings/ca_about.png", uri: "/about"} )
                theDataModel.append( {name: qsTr("Accessibility"), description: qsTr("Magnification, TTY settings"), imageSource: "images/settings/ca_accessibility.png", uri: "/accessibility"} )
                theDataModel.append( {name: qsTr("Bluetooth"), description: qsTr("Bluetooth connections"), imageSource: "images/settings/ca_bluetooth.png", uri: "/bluetooth"} )
                theDataModel.append( {name: qsTr("Certificates"), description: qsTr("Manage public and private keys"), imageSource: "images/settings/ca_certificates.png", uri: "/certificates"} )
                theDataModel.append( {name: qsTr("Date and Time"), description: qsTr("Time zones, display format"), imageSource: "images/settings/ca_date_time.png", uri: "/datetime"} )
                theDataModel.append( {name: qsTr("Development Mode"), description: qsTr("Enable software development tools"), imageSource: "images/settings/ca_development_mode.png", uri: "/devmode"} )
                theDataModel.append( {name: qsTr("Device Password"), description: qsTr("Control access to your device"), imageSource: "images/settings/ca_passwords.png", uri: "/password"} )
                theDataModel.append( {name: qsTr("Display"), description: qsTr("Screen lock, brightness, wallpaper"), imageSource: "images/settings/ca_display.png", uri: "/display"} )
                theDataModel.append( {name: qsTr("Internet Tethering"), description: qsTr("Tethering"), imageSource: "images/settings/ca_tethering.png", uri: "/tethering"} )
                theDataModel.append( {name: qsTr("Language and Input"), description: qsTr("Keyboard, spell check, prediction"), imageSource: "images/settings/ca_language_input.png", uri: "/language"} )
                theDataModel.append( {name: qsTr("Main Volume"), description: qsTr("Volume for media and apps"), imageSource: "images/settings/ca_system_volume.png", uri: "/sound"} )
                theDataModel.append( {name: qsTr("Media Sharing"), description: qsTr("Connect to a TV, computer, stereo"), imageSource: "images/settings/ca_sharing_files.png", uri: "/sharing"} )
                theDataModel.append( {name: qsTr("Mobile Hotspot"), description: qsTr("Mobile Hotspot"), imageSource: "images/settings/ca_mobile_hotspot.png", uri: "/mhs"} )
                theDataModel.append( {name: qsTr("Mobile Network"), description: qsTr("Mobile Network"), imageSource: "images/settings/ca_mobile_network.png", uri: "/radio"} )
                theDataModel.append( {name: qsTr("NFC"), description: qsTr("NFC"), imageSource: "images/settings/ca_nfc.png", uri: "/nfc"} )
                theDataModel.append( {name: qsTr("Notifications"), description: qsTr("Ringtones, sounds, vibrate, LED"), imageSource: "images/settings/ca_notification.png", uri: "/notification"} )
                theDataModel.append( {name: qsTr("Parental Controls"), description: qsTr("Child Protection"), imageSource: "images/settings/ca_parental_controls.png", uri: "/childprotection"} )
                theDataModel.append( {name: qsTr("Security and Privacy"), description: qsTr("Permissions, passwords, wipe"), imageSource: "images/settings/ca_security_privacy.png", uri: "/security"} )
                theDataModel.append( {name: qsTr("Storage and Access"), description: qsTr("Device data access, media card"), imageSource: "images/settings/ca_storage_access.png", uri: "/storage"} )
                theDataModel.append( {name: qsTr("VPN"), description: qsTr("Virtual Private Network"), imageSource: "images/settings/ca_vpn.png", uri: "/vpn"} )
                theDataModel.append( {name: qsTr("Wi-Fi"), description: qsTr("Wi-Fi"), imageSource: "images/settings/ca_wifi.png", uri: "wifi"} )
            }
            
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            
            onTriggered: {
                var value = theDataModel.data(indexPath)

                sql.query = "INSERT INTO gestures (sequence, type, uri) VALUES('%1','setting','%2')".arg(sequence).arg(data.uri);
                sql.load(5);
                
                properties.navPane.pop();
                properties.navPane.pop();
            }
        }
    }
}