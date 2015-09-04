import UIKit
import MapKit

public class BusinessesMapTableView: UIView {
    
    // MARK: IBOutlets
    
    @IBOutlet public var mapView: MKMapView!
    @IBOutlet public var tableView: UITableView!
    @IBOutlet public var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Subview Stylization
    
    public func styleSubviews() {
        mapView.rotateEnabled = false
        mapView.pitchEnabled = false
    }
    
    // MARK: Map Updates
    
    public func panMapToBatonRouge() {
        mapView.setRegion(BatonRouge.coordinateRegion, animated: true)
    }
    
    public func updateMapAnnotations(annotations: [MKAnnotation]) {
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)
    }
    
}