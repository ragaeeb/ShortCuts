import bb.cascades 1.0

Page {
    property alias contentContainer: contentContainer.controls
    property alias titleContainer: titleBarRef
    property alias rootContainer: topLevel.controls
    property alias root: topLevel
    
    Container
    {
        layout: DockLayout {}
        id: topLevel
        
	    Container {
	        TitleContainer {
	        	id: titleBarRef
	        }
	        
	        horizontalAlignment: HorizontalAlignment.Fill
	        verticalAlignment: VerticalAlignment.Fill
	
	        Container // This container is replaced
	        {
	            layout: DockLayout {
	                
	            }
	            
	            id: contentContainer
	            objectName: "contentContainer"
	            
	            horizontalAlignment: HorizontalAlignment.Fill
	            verticalAlignment: VerticalAlignment.Fill
	
	            layoutProperties: StackLayoutProperties {
	                spaceQuota: 1
	            }
	
	            ImageView {
	                imageSource: "images/bottomDropShadow.png"
	                topMargin: 0
	                leftMargin: 0
	                rightMargin: 0
	                bottomMargin: 0
	
	                horizontalAlignment: HorizontalAlignment.Fill
	                verticalAlignment: VerticalAlignment.Top
	            }
	        }
	    }
    }
}