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
    }

	ImageView {
	    imageSource: logoImage
	    topMargin: 0
	    leftMargin: 0
	    rightMargin: 0
	    bottomMargin: 0
	    
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
	}
}