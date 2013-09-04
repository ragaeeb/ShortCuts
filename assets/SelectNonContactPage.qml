import bb.cascades 1.0
import QtQuick 1.0

Page
{
    property string sequence
    
    paneProperties: NavigationPaneProperties {
        property variant navPane: navigationPane
        id: properties
    }
    
    titleBar: TitleBar {
        title: qsTr("Non-Contact") + Retranslate.onLanguageChanged
        kind: TitleBarKind.Segmented
        options: [
            Option {
                id: phoneOption
                property string hint: qsTr("6135601000")
                property string message: qsTr("Please enter the phone number you wish to dial when this gesture is performed:") + Retranslate.onLanguageChanged
                text: qsTr("Phone") + Retranslate.onLanguageChanged
                value: "phone"
            },
            
            Option {
                id: emailOption
                property string hint: qsTr("support@canadainc.org")
                property string message: qsTr("Please enter the email address you wish to map this gesture to:") + Retranslate.onLanguageChanged
                text: qsTr("Email") + Retranslate.onLanguageChanged
                value: "email"
            },
            
            Option {
                id: smsOption
                property string hint: qsTr("6135601000")
                property string message: qsTr("Please enter the mobile number you wish to text when this gesture is performed:") + Retranslate.onLanguageChanged
                text: qsTr("SMS") + Retranslate.onLanguageChanged
                value: "sms"
            }
        ]
        
        onSelectedOptionChanged: {
            instructions.text = selectedOption.message;
            textField.loseFocus();
            textField.resetText();
            textField.hintText = selectedOption.hint;
            timer.running = true;
        }
    }
    
    actions: [
        ActionItem {
            id: saveAction
            title: qsTr("Save") + Retranslate.onLanguageChanged
            imageSource: "images/ic_save.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: textField.validator.valid
            
            onTriggered: {
                textField.validator.validate();
                
                if (textField.validator.valid) {
                    app.registerShortcut(sequence, titleBar.selectedValue, textField.text);
                    properties.navPane.pop();
                    properties.navPane.pop();
                }
            }
        }
    ]
    
    Container
    {
        topPadding: 20; leftPadding: 20; rightPadding: 20
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Label {
            id: instructions
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            text: titleBar.selectedOption.message
        }
        
        Divider {
            topMargin: 0; bottomMargin: 0
        }
        
        TextField {
            id: textField
            hintText: titleBar.selectedOption.hint
            horizontalAlignment: HorizontalAlignment.Fill
            inputRoute.primaryKeyTarget: true
            
            validator: Validator
            {
                errorMessage: qsTr("Invalid Entry") + Retranslate.onLanguageChanged
                
                onValidate:
                {
                    if (titleBar.selectedOption == emailOption) {
                        var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                        valid = regex.test(textField.text);
                    } else {
                        valid = textField.text.length > 2;                        
                    }
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
                    id: timer
                    running: true
                    interval: 150
                    repeat: false
                    
                    onTriggered: {
                        if (titleBar.selectedOption == emailOption) {
                        	textField.inputMode = TextFieldInputMode.EmailAddress;
                        } else {
                        	textField.inputMode = TextFieldInputMode.PhoneNumber;
                        }
                        
                        textField.requestFocus();
                    }
                }
            ]
        }
    }
}