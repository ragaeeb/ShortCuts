import bb.cascades 1.0

BaseRegisterPage
{
    id: root
    
    actions: [
        ActionItem {
            id: saveAction
            title: qsTr("Save")
            imageSource: "file:///usr/share/icons/bb_action_saveas.png"
            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                if (saveAction.enabled)
                {
                    var patt1=/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
                    var result = patt1.test(textField.text)
                    
                    if (result) {
                    	app.registerUri(sequence, textField.text)
                    } else {
                        persist.showToast("Invalid URL")
                    }
                }
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
            text: qsTr("http://") + Retranslate.onLanguageChanged
            
            input {
                submitKey: SubmitKey.Submit
                
                onSubmitted: {
                	saveAction.triggered()
                }
            }
        }
    }
}