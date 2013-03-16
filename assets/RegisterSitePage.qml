import bb.cascades 1.0

BaseRegisterPage
{
    id: root
    
    actions: [
        ActionItem {
            id: saveAction
            title: qsTr("Save")
            imageSource: "asset:///images/ic_save.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: false

            onTriggered: {
                app.registerUri(sequence, textField.text)
            }
        }
    ]
    
    contentContainer: Container
    {
        topPadding: 20; leftPadding: 20; rightPadding: 20;
        
        Label {
            text: qsTr("Enter the address:")
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
        }
        
        TextField {
            id: textField
            topPadding: 20
            horizontalAlignment: HorizontalAlignment.Fill
            hintText: qsTr("http://abdurrahman.org")
            inputMode: TextFieldInputMode.Url
            text: qsTr("http://")
            
            validator: Validator {
                mode: ValidationMode.Immediate
                errorMessage: qsTr("Invalid URL")
                onValidate: {
                    var patt1=/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
                    var result = patt1.test(textField.text)
                    state = result ? ValidationState.Valid : ValidationState.Invalid
                }
                
                onStateChanged: {
                    saveAction.enabled = state == ValidationState.Valid
                }
            }
            
            input {
                submitKey: SubmitKey.Submit
                
                onSubmitted: {
                    if (saveAction.enabled) {
                        saveAction.triggered()
                    }
                }
            }
        }
    }
}