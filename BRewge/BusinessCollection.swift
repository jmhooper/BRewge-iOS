import Foundation
import CoreLocation

public class BusinessCollection: NSObject {
    
    // MARK: Instance Variables
    
    public var businesses: [Business] = []
    
    // MARK: Subscript overrides
    
    public subscript(index: Int) -> Business {
        get {
            return businesses[index]
        }
        set(newValue) {
            businesses[index] = newValue
        }
    }
    
    // MARK: Sorting
    
    private let timeFactor = 100
    
    public func sortForLocation(location: CLLocation) {
        businesses.sort({ (businessA: Business, businessB: Business) -> Bool in
            let distanceA = businessA.location.distanceFromLocation(location)
            let distanceB = businessB.location.distanceFromLocation(location)
            return distanceA < distanceB
        })
    }
    
    public func sortByName() {
        businesses.sort({ (businessA: Business, businessB: Business) -> Bool in
            return businessA.name < businessB.name
        })
    }
    
    // MARK: Array forwards
    
    public func count() -> Int {
        return businesses.count
    }
    
    public func append(business: Business) {
        businesses.append(business)
    }
}
