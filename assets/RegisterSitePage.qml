import bb.cascades 1.0
import QtQuick 1.0

Page
{
    id: root
    property string sequence
    
    titleBar: TitleBar {
        title: qsTr("Open Website") + Retranslate.onLanguageChanged
    }
    
    actions: [
        ActionItem {
            id: saveAction
            title: qsTr("Save")
            imageSource: "images/ic_save.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: textField.validator.valid

            onTriggered: {
                textField.validator.validate();
                
                if (textField.validator.valid) {
                    app.registerShortcut(sequence, "url", textField.text);
                    properties.navPane.pop();
                    properties.navPane.pop();
                }
            }
        }
    ]
    
    Container
    {
        topPadding: 20; leftPadding: 20; rightPadding: 20;
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Label {
            text: qsTr("Enter the address:")
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
        }
        
        TextField {
            id: textField
            topPadding: 20
            horizontalAlignment: HorizontalAlignment.Fill
            hintText: qsTr("http://abdurrahman.org") + Retranslate.onLanguageChanged
            inputMode: TextFieldInputMode.Url
            inputRoute.primaryKeyTarget: true
            text: qsTr("http://") + Retranslate.onLanguageChanged
            
            validator: Validator
            {
                errorMessage: qsTr("Invalid URL") + Retranslate.onLanguageChanged

                onValidate: { 
                    var regex=/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
                    valid = regex.test(textField.text);
                }
            }
            
            input {
                submitKey: SubmitKey.Submit
                
                onSubmitted: {
                	saveAction.triggered();
                }
            }
            
            attachedObjects: [
                Timer {
                    running: true
                    interval: 150
                    repeat: false
                    
                    onTriggered: {
                        textField.requestFocus();
                    }
                }
            ]
        }
    }
}