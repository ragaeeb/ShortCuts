import bb.cascades 1.0

Container
{
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    layout: DockLayout {}
    
    Label {
        textStyle.base: SystemDefaults.TextStyles.SmallText
        text: qsTr("%1 shortcuts registered...").arg(app.numShortcuts) + Retranslate.onLanguageChanged
        multiline: true
        textStyle.textAlign: TextAlign.Center
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Center
    }
}