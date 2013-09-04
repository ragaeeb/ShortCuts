import bb.cascades 1.0
import bb 1.0

Page
{
    attachedObjects: [
        ApplicationInfo {
            id: appInfo
        },

        PackageInfo {
            id: packageInfo
        }
    ]
    
    titleBar: TitleBar {
        title: qsTr("Help") + Retranslate.onLanguageChanged
    }

    Container
    {
        leftPadding: 20; rightPadding: 20;

        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Fill

        ScrollView {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill

            Label {
                multiline: true
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                textStyle.textAlign: TextAlign.Center
                textStyle.fontSize: FontSize.Small
                content.flags: TextContentFlag.ActiveText
                text: qsTr("\n\n(c) 2013 %1. All Rights Reserved.\n%2 %3\n\nPlease report all bugs to:\nsupport@canadainc.org\n\nA full touch device makes it hard to do the tasks you do often efficiently. Since there are no physical keys, it may take several steps to open a file you want, or call someone, or go to a specific website.\n\nTo help you get around this problem, we wrote Sweep. This app allows you to register an unlimited combination of gestures and keys to perform various tasks on your phone. Examples of these tasks are to call your contacts, or open your favourite website, or open your favourite media, or start a BBM conversation/call. You can also use it to launch other apps like a specific screen of the BlackBerry 10 Settings app.\n\nThe gestures can be as simple or as complex as you like. For example you can set that swiping down twice calls your friend Ahmed. You can also set that swiping down only once will call Abdullah. You can set that swiping down, then swiping up, then swiping right opens the website http://abdurrahman.org. You can set swiping down, then pressing the physical key 'L' starts a BBM Video call with Leila. The possibilities are endless!\n\n").arg(packageInfo.author).arg(appInfo.title).arg(appInfo.version)
            }
        }
    }
}
