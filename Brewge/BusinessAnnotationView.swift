import UIKit
import MapKit

public class BusinessAnnotationView: MKPinAnnotationView {
    
    // MARK: Instance Variables
    
    public var business: Business {
        return annotation as! Business
    }
    
    // MARK: Initialization
    
    public init(business: Business) {
        super.init(
            annotation: business,
            reuseIdentifier: nil
        )
        canShowCallout = true
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        canShowCallout = true
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        canShowCallout = true
    }
}