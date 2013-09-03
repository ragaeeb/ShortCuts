import bb.cascades 1.0
import com.canadainc.data 1.0

Page
{
    property string sequence
    
    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
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
                theDataModel.append( { name: qsTr("BBM"), source: "SelectBBMContactPage.qml", imageSource: "file:///usr/share/icons/ic_start_bbm_chat.png", description: qsTr("BBM, BBM Voice, BBM Video") } );
                theDataModel.append( { name: qsTr("Contact"), source: "SelectContactPage.qml", imageSource: "images/ic_user.png" , description: qsTr("Email, SMS, & Phone")} );
                theDataModel.append( { name: qsTr("Launch Settings"), source: "SelectSettingPage.qml", imageSource: "images/ic_settings.png", description: qsTr("BB10 Settings") } );
                theDataModel.append( { name: qsTr("Open"), source: "RegisterFilePage.qml", imageSource: "images/ic_open_file.png", description: qsTr("Open File") } );
            }
            
            onTriggered: {
                var src = dataModel.data(indexPath).source;
                
                if (src == "SelectContactPage.qml")
                {
                    var ok = pimUtil.validateContactsAccess( qsTr("Warning: It seems like the app does not have access to your contacts. This permission is needed for the app to access your address book so we can allow shortcuts of the data to be created. If you leave this permission off, some features may not work properly. Select OK to launch the Application Permissions screen where you can turn these settings on.") );
                    
                    if (!ok) {
                        return;
                    }
                }
                
                pageDefinition.source = src;
                var page = pageDefinition.createObject();
                page.sequence = sequence;
                
                properties.navPane.push(page);
            }
            
            attachedObjects: [
                ComponentDefinition {
                    id: pageDefinition
                },
                
                PimUtil {
                    id: pimUtil
                }
            ]
        }
        
        onCreationCompleted: {
            if ( persist.getValueFor("reportTutorialCount") < 1 ) {
                persist.showToast( qsTr("Want to see a specific app integrated into Sweep that's not already here? You can send your request to the development team by:\n\n1) Swipe-down from the top-bezel.\n2) Choose Bug-Report.\n3) Fill out a feature request and specify the app you want us to look at and specifically what features you want to have integrated."), qsTr("OK") );
                persist.saveValueFor("reportTutorialCount", 1);
            }
        }
    }
}