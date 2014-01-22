import bb.cascades 1.0
import bb.device 1.0
import bb.cascades.pickers 1.0

Page
{
    actions: [
        ActionItem
        {
            title: qsTr("Import") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "images/ic_import.png"
            
            onTriggered: {
                filePicker.title = qsTr("Select File");
                filePicker.mode = FilePickerMode.Picker
                
                filePicker.open();
            }
        },
        
        ActionItem
        {
            title: qsTr("Export") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "images/ic_export.png"
            
            onTriggered: {
                filePicker.title = qsTr("Select Destination");
                filePicker.mode = FilePickerMode.Saver
                filePicker.defaultSaveFileNames = ["sweep.db"]
                filePicker.allowOverwrite = true;
                
                filePicker.open();
            }
        }
    ]
    
    attachedObjects: [
        FilePicker {
            id: filePicker
            defaultType: FileType.Other
            filter: ["*.db"]

            directories :  {
                return ["/accounts/1000/removable/sdcard/downloads", "/accounts/1000/shared/downloads"]
            }
            
            onFileSelected : {
                var success;
                
                if (mode == FilePickerMode.Picker) {
                    success = app.importGestures(selectedFiles[0]);
                    
                    if (success) {
                        persist.showToast( qsTr("Successfully imported gestures, please restart the app!") );
                    } else {
                        persist.showToast( qsTr("Failed to import gestures...") );
                    }
                } else {
                    success = app.exportGestures(selectedFiles[0]);

                    if (success) {
                        persist.showToast( qsTr("Successfully saved gestures!") );
                    } else {
                        persist.showToast( qsTr("Failed to save the gestures...") );
                    }
                }
            }
        }
    ]
    
    titleBar: TitleBar {
        title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
    ScrollView
    {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Container
        {
            leftPadding: 20; topPadding: 20; rightPadding: 20; bottomPadding: 20
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            SliderPair
            {
                labelValue: qsTr("Processing Delay") + Retranslate.onLanguageChanged
                from: 1
                to: 3
                key: "processingDelay"
                
                onSliderValueChanged: {
                    infoText.text = qsTr("Gestures will be interpreted after %1 seconds. Note that if this is too short, and you have some complex gestures, it might make it harder for the system to always interpret them. If your gestures are not always recognized properly, increase this value.").arg(sliderValue);
                }
            }
            
            SettingPair {
                topMargin: 20
                title: qsTr("Medium Font Size") + Retranslate.onLanguageChanged
                key: "mediumFont"
                
                toggle.onCheckedChanged: {
                    if (checked) {
                        infoText.text = qsTr("Medium font size will be used for the gesture summary.");
                    } else {
                        infoText.text = qsTr("Extra small font size wil be used for the gesture summary.");
                    }
                }
            }
            
            SettingPair {
                topMargin: 20
                title: qsTr("Allow Play/Pause Key Focus") + Retranslate.onLanguageChanged
                key: "allowFocus"
                
                toggle.onCheckedChanged: {
                    if (checked) {
                        infoText.text = qsTr("The play/pause key (voice command key) will automatically focus the app if the app is at least in active frame mode.");
                    } else {
                        infoText.text = qsTr("The play/pause key will not bring the app into focus.");
                    }
                }
            }
            
            SettingPair {
                topMargin: 20
                title: qsTr("Show Virtual Keyboard") + Retranslate.onLanguageChanged
                key: "showVKB"
                visible: !hw.isPhysicalKeyboardDevice
                
                toggle.onCheckedChanged: {
                    if (checked) {
                        infoText.text = qsTr("The virtual keyboard will be displayed on app startup.");
                    } else {
                        infoText.text = qsTr("The virtual keyboard will be hidden on app startup.");
                    }
                }
                
                attachedObjects: [
                    HardwareInfo {
                        id: hw
                    }
                ]
            }
            
            Label {
                topMargin: 40
                id: infoText
                multiline: true
                textStyle.fontSize: FontSize.XXSmall
                textStyle.textAlign: TextAlign.Center
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
    }
}