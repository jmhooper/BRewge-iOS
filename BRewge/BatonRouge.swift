import MapKit

public struct BatonRouge {
    
    public static let coordinates = CLLocationCoordinate2D(
        latitude: 30.4500,
        longitude: -91.100
    )
    
    public static let coordinateSpan = MKCoordinateSpan(
        latitudeDelta: 0.5,
        longitudeDelta: 0.5
    )
    
    public static let coordinateRegion: MKCoordinateRegion = {
        return MKCoordinateRegion(
            center: coordinates,
            span: coordinateSpan
        )
    }()
    
}