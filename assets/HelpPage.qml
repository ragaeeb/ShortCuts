import bb.cascades 1.0
import bb 1.0

BasePage
{
    attachedObjects: [
        ApplicationInfo {
            id: appInfo
        },

        PackageInfo {
            id: packageInfo
        }
    ]

    contentContainer: Container
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
                text: qsTr("\n\n(c) 2013 %1. All Rights Reserved.\n%2 %3\n\nPlease report all bugs to:\nsupport@canadainc.org\n\nA full touch device makes it hard to do the tasks you do often efficiently. Since there are not physical keys, it may take several steps to open a file you want, or call someone, or go to a specific website.\n\nTo help you get around this problem, we wrote Short Cuts! This app allows you to register an unlimited combination of gestures to call your contacts, or open your favourite website, or open your favourite media, etc. You can also use it to launch other apps like a specific screen of the BB10 Settings app.\n\nThe gestures can be as simple or as complex as you like. For example you can set that swiping down twice calls your friend Joe. You can also set that swiping down only once will call Jill. You can set that swiping down, then swiping up, then swiping right opens http://abdurrahman.org.\n\nThe possibilities are endless. Several gestures are supported. You can use pinches (zoom), swipe up, down, left, right, diagonal up, diagonal down (either left or right), single tap, or double tap, any of the physical keyboard letters, and you can use these gestures in any combination you choose!\n\nAnd now Short Cuts has support for the Q10, so you can type in any key combination to do any of the actions you would do with gestures.\n\n").arg(packageInfo.author).arg(appInfo.title).arg(appInfo.version)
            }
        }
    }
}
