import bb.cascades 1.0

Container
{
    attachedObjects: [
        ImagePaintDefinition {
            id: back
            imageSource: "images/title_bg.png"
        }
    ]
    
    background: back.imagePaint
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Center
    layout: DockLayout {}
    
    ImageView {
        imageSource: "images/logo.png"
        topMargin: 0
        leftMargin: 0
        rightMargin: 0
        bottomMargin: 0

        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
    }
    
    Label {
        textStyle.base: SystemDefaults.TextStyles.SmallText
        text: qsTr("%1 shortcuts registered...").arg(app.numShortcuts) + Retranslate.onLanguageChanged
        multiline: true
        textStyle.textAlign: TextAlign.Center
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Bottom
    }
}