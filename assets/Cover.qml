import bb.cascades 1.0

Container
{
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    layout: DockLayout {}
    background: Color.Black
    
    RecordedGesturesLabel {
        id: recorded
        verticalAlignment: VerticalAlignment.Center
    }
}