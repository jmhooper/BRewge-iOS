import Foundation
import CoreLocation
import MapKit

public class Business: NSObject, MKAnnotation {
    
    public let name: String
    public let address: String
    public let location: CLLocation
    
    public init(name: String, address: String, location: CLLocation) {
        self.name = name
        self.address = address
        self.location = location
    }
    
    // MARK: MapKit
    
    public func openInAppleMaps() {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        let mapOptions = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: BatonRouge.coordinates),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: BatonRouge.coordinateSpan)
        ]
        mapItem.openInMapsWithLaunchOptions(mapOptions)
    }
    
    // MARK: MKAnnotation
    
    public var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    public var title: String {
        return name
    }
    
    public var subtitle: String {
        return address
    }
    
}
