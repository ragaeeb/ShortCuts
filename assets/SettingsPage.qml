import bb.cascades 1.0

Page
{
    titleBar: TitleBar {
        title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
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
        
        Label {
            id: infoText
            multiline: true
            textStyle.fontSize: FontSize.XXSmall
            textStyle.textAlign: TextAlign.Center
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
}