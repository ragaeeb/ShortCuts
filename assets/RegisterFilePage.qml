import bb.cascades 1.0
import bb.cascades.pickers 1.0

Page
{
    property string sequence
    
    Container
    {
        topPadding: 20
        
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        onCreationCompleted: {
            filePicker.open();
        }
        
        attachedObjects: [
			FilePicker {
			    id: filePicker
                title : qsTr("Select File") + Retranslate.onLanguageChanged
                
                directories :  {
                    return ["/accounts/1000/removable/sdcard", "/accounts/1000/shared/voice"]
                }
                
                onFileSelected : {
                    app.registerShortcut(sequence, "file", selectedFiles[0]);
                    properties.navPane.pop();
                    properties.navPane.pop();
                }
			}
        ]
        
        Button {
            text: qsTr("Select File") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            
            onClicked: {
                filePicker.open()
            }
        }
    }
}
