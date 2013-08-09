import bb.cascades 1.0

Container {
    property string backgroundImage: "images/title_bg.amd"
    property string logoImage: "images/logo.png"
    
    layout: DockLayout {}

    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Top

    ImageView {
        imageSource: backgroundImage
        topMargin: 0
        leftMargin: 0
        rightMargin: 0
        bottomMargin: 0

        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
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

	ImageView {
	    imageSource: logoImage
	    topMargin: 0
	    leftMargin: 0
	    rightMargin: 0
	    bottomMargin: 0
	    
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
	
	    animations: [
	        FadeTransition {
	            id: fade
	            duration: 1000
	            easingCurve: StockCurve.CubicIn
	            fromOpacity: 0
	            toOpacity: 1
	        },
	
	        TranslateTransition {
	            id: translate2
	            toY: 0
	            fromX: 200
	            duration: 1000
	        }
	    ]
	    
	    onCreationCompleted:
	    {
	        if ( persist.getValueFor("animations") == 1 )
	        {
	            fade.play()
	            translate2.play()
	        }
	    }
	}
}