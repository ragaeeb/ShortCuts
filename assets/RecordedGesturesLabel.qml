import bb.cascades 1.0
import com.canadainc.data 1.0

Label
{
    multiline: true
    horizontalAlignment: HorizontalAlignment.Fill
    textStyle.textAlign: TextAlign.Center
    enabled: false
    
    function onDataLoaded(id, data)
    {
        if (id == QueryId.GetAll)
        {
            if (data.length > 0)
            {
                var result = "";
                
                for (var i = data.length-1; i >= 0; i--)
                {
                    if (data.type == "file")
                    {
                        var uri = data[i].uri;
                        var lastSlash = uri.lastIndexOf("/");
                        uri = uri.substring(lastSlash+1);
                        
                        result += "[%1: %2]\n".arg(data[i].sequence).arg(uri);
                    } else {
                        result += "[%1: %2]\n".arg(data[i].sequence).arg(data[i].uri);
                    }
                }
                
                text = result;
            } else {
                text = qsTr("No gestures have yet been registered for shortcuts. To add shortcuts, simply perform a gesture (ie: two consecutive swipe ups) and you will be asked to attach it with an action.");
            }
        }
    }
    
    function onSettingChanged(key)
    {
        if (key == "mediumFont") {
            textStyle.fontSize = persist.getValueFor("mediumFont") == 1 ? FontSize.XSmall : FontSize.XXSmall;
        }
    }
    
    onCreationCompleted: {
        persist.settingChanged.connect(onSettingChanged);
        sql.dataLoaded.connect(onDataLoaded);
        app.requestAllShortcuts();
        onSettingChanged("mediumFont");
    }
}