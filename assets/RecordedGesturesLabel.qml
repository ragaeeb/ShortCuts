import bb.cascades 1.0

Label
{
    multiline: true
    textStyle.fontSize: FontSize.XXSmall
    horizontalAlignment: HorizontalAlignment.Fill
    textStyle.textAlign: TextAlign.Center
    enabled: false
    
    function onDataLoaded(id, data)
    {
        if (id == 2)
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
        }
    }
    
    onCreationCompleted: {
        sql.dataLoaded.connect(onDataLoaded);

        sql.query = "SELECT sequence,uri,type FROM gestures";
        sql.load(2);
    }
}