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
            
            for (var i = data.length-1; i >= 0; i--) {
                result += data[i].sequence + "\n";
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