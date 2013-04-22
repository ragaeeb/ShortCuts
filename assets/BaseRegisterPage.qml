import bb.cascades 1.0

Page
{
    property string sequence
    property alias contentContainer: contentContainer.controls
    
    Container {
        TitleContainer {
        	id: titleBar
            backgroundImage: "asset:///images/dialog_title_bg.png"
            logoImage: "asset:///images/register_dialog_title_text.png"
            preferredHeight: 100
        }
        
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        Container // This container is replaced
        {
            layout: DockLayout {}
            
            id: contentContainer
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }

            ImageView {
                imageSource: "asset:///images/bottomDropShadow.png"
                topMargin: 0
                leftMargin: 0
                rightMargin: 0
                bottomMargin: 0

                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Top
                
                animations: [
                    TranslateTransition {
                        id: translate
                        toY: 0
                        fromY: -100
                        duration: 1000
                    }
                ]
                
		        onCreationCompleted:
		        {
		            if ( persist.getValueFor("animations") == 1 ) {
		                translate.play()
		            }
		        }
            }
        }
    }
}