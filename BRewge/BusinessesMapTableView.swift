import UIKit
import MapKit

public class BusinessesMapTableView: UIView {
    
    // MARK: IBOutlets
    
    @IBOutlet public var mapView: MKMapView!
    @IBOutlet public var tableView: UITableView!
    @IBOutlet public var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet public var viewContextSegmentedControl: UISegmentedControl!
    
    // MARK: View Lifecycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        styleSubviews()
    }
    
    // MARK: Subview Stylization
    
    private func styleSubviews() {
        mapView.rotateEnabled = false
        mapView.pitchEnabled = false
    }
    
    // MARK: Map Updates
    
    public func panMapToInitialLocation() {
        if mapView.userLocation.location != nil {
            panMapToUserLocation()
        } else {
            panMapToBatonRoute()
        }
    }
    
    private func panMapToBatonRoute() {
        mapView.setRegion(BatonRouge.coordinateRegion, animated: true)
    }
    
    private func panMapToUserLocation() {
        if let userLocation = mapView.userLocation.location {
            mapView.setRegion(
                MKCoordinateRegion(
                    center: userLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                ),
                animated: true
            )
        } else {
            panMapToBatonRoute()
        }
    }
    
    public func updateMapAnnotations(annotations: [MKAnnotation]) {
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)
    }
    
    // MARK: View Context Updates
    
    @IBAction public func viewContrextSegmentedControlChangedContexts() {
        if viewContextSegmentedControl.selectedSegmentIndex == 0 {
            mapView.hidden = false
            tableView.hidden = true
        } else if viewContextSegmentedControl.selectedSegmentIndex == 1 {
            mapView.hidden = true
            tableView.hidden = false
        }
    }
    
}