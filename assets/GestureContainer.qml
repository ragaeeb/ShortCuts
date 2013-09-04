import bb.cascades 1.0
import QtQuick 1.0

Container
{
    id: gestureContainer
    
    property bool active: true
    property variant array: []
    property int downX;
    property int downY;
    property double correction: 75
    
    signal sequenceCompleted(variant sequence)
    signal gestureAdded(string value);
    
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
    
    function recordGesture(value)
    {
        if (active)
        {
	        timer.start();
	        
	        var copy = array;
	        copy.push(value);
	        array = copy;
	        
	        gestureAdded(value);
        }
    }
    
    onActiveChanged:
    {
        if (active)
        {
	        var emptyArray = []
	        array = emptyArray
        }
    }
    
    layout: AbsoluteLayout {}
    
    gestureHandlers: [
        TapHandler {
            onTapped: {
                gestureContainer.recordGesture("Tap")
            }
        },
        
        DoubleTapHandler {
            onDoubleTapped: {
                gestureContainer.recordGesture("DoubleTap")
            }
        },
        
        PinchHandler {
            onPinchEnded: {
                gestureContainer.recordGesture("Pinch")
            }
        }
    ]
    
    attachedObjects: [
        Timer {
            id: timer
            repeat: false
            interval: persist.getValueFor("processingDelay")*1000
            
            onTriggered: {
                sequenceCompleted(gestureContainer.array)
                var array = []
                gestureContainer.array = array
            }
        }
    ]
    
    function onSettingChanged(key)
    {
        if (key == "processingDelay") {
            timer.interval = persist.getValueFor("processingDelay")*1000;
        }
    }
    
    onCreationCompleted: {
        persist.settingChanged.connect(onSettingChanged);
    }
    
	ImageView {
	    id: fingerprint
	    imageSource: "images/fingerprint.png"
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
                    recordGesture("Left")
                } else if ((event.windowX - downX) > 320) {
                    recordGesture("Right")
                }
            } else if (xDiff < 200) {
	            if ((downY - event.windowY) > 320) {
	                recordGesture("Up")
	            } else if ( (event.windowY - downY) > 320 ) {
	                recordGesture("Down")
	            }
            } else if (yDiff >= 200 && xDiff >= 200) { // diagonal swipe
                if ( (downX - event.windowX) > 320 && (downY - event.windowY) > 320 ) {
                    recordGesture("UpLeft")
                } else if ( (event.windowX - downX) > 320 && (downY - event.windowY) > 320 ) {
                    recordGesture("UpRight")
                } if ( (downX - event.windowX) > 320 && (event.windowY - downY) > 320 ) {
                    recordGesture("DownLeft")
                } else if ( (event.windowX - downX) > 320 && (event.windowY - downY) > 320 ) {
                    recordGesture("DownRight")
                }
            }
            
            fingerprint.visible = false
        } else if ( event.isMove() ) {
            alp.positionX = event.localX-correction
            alp.positionY = event.localY-correction
        }
    }
}