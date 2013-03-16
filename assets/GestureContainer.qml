import bb.cascades 1.0

Container
{
    property int downX;
    property int downY;
    property double correction: 75
    
    signal swipedLeft();
    signal swipedRight();
    signal swipedDown();
    signal swipedUp();
    signal swipedUpLeft();
    signal swipedUpRight();
    signal swipedDownLeft();
    signal swipedDownRight();
    
    function shake(control)
    {
        var rand = Math.random()*2
        if (rand < 1) {
            rand = -1
        } else {
            rand = 1
        }
        
		control.translationX = rand*(Math.random()*5);
		control.translationY = rand*(Math.random()*5);
		control.rotationZ = rand* Math.random()*6;
    }
    
    layout: AbsoluteLayout {
        
    }
    
	ImageView {
	    id: fingerprint
	    imageSource: "asset:///images/fingerprint.png"
	    topMargin: 0
	    leftMargin: 0
	    rightMargin: 0
	    bottomMargin: 0
	    visible: false
	    preferredHeight: 200
        scalingMethod: ScalingMethod.AspectFit
	    
        layoutProperties: AbsoluteLayoutProperties {
            id: alp
        }
	}
    
    onTouch: {
        if ( event.isDown() ) {
            downX = event.windowX;
            downY = event.windowY;
            fingerprint.visible = true
            alp.positionX = event.localX-correction
            alp.positionY = event.localY-correction
        } else if ( event.isUp() ) {
            var yDiff = downY - event.windowY;
            var xDiff = downX - event.windowX;

            if (yDiff < 0) {
                yDiff = -1 * yDiff;
            }
            
            if (xDiff < 0) {
                xDiff = -1 * xDiff;
            }
            
            if (yDiff < 200) {
                if ((downX - event.windowX) > 320) {
                    swipedLeft();
                } else if ((event.windowX - downX) > 320) {
                    swipedRight();
                }
            } else if (xDiff < 200) {
	            if ((downY - event.windowY) > 320) {
	                swipedUp();
	            } else if ( (event.windowY - downY) > 320 ) {
	                swipedDown();
	            }
            } else if (yDiff >= 200 && xDiff >= 200) { // diagonal swipe
                if ( (downX - event.windowX) > 320 && (downY - event.windowY) > 320 ) {
                    swipedUpLeft();
                } else if ( (event.windowX - downX) > 320 && (downY - event.windowY) > 320 ) {
                    swipedUpRight();
                } if ( (downX - event.windowX) > 320 && (event.windowY - downY) > 320 ) {
                    swipedDownLeft();
                } else if ( (event.windowX - downX) > 320 && (event.windowY - downY) > 320 ) {
                    swipedDownRight();
                }
            }
            
            fingerprint.visible = false
        } else if ( event.isMove() ) {
            alp.positionX = event.localX-correction
            alp.positionY = event.localY-correction
        }
    }
}