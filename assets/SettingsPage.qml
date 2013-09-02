import bb.cascades 1.0

Page
{
    Container
    {
        leftPadding: 20; topPadding: 20; rightPadding: 20; bottomPadding: 20
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        SliderPair
        {
            labelValue: qsTr("Processing Delay") + Retranslate.onLanguageChanged
            from: 900
            to: 3000
            key: "delay"
            
            onSliderValueChanged: {
                infoText.text = qsTr("Gestures will be interpreted after %1 seconds. Note that if this is too short, and you have some complex gestures, it might make it harder for the system to always interpret them. If your gestures are not always recognized properly, increase this value.").arg(value/1000)
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