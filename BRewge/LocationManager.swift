import Foundation
import CoreLocation

class LocationRequest: NSObject {
    var success: ((location: CLLocation) -> Void)!
    var failure: ((error: NSError) -> Void)!
}

var sharedLocationManager: LocationManager!

class LocationManager : CLLocationManager, CLLocationManagerDelegate {
    
    var locationRequests: [LocationRequest] = []
    var isLoadingLocation: Bool = false
    
    class func sharedManager() -> LocationManager {
        if sharedLocationManager == nil {
            sharedLocationManager = LocationManager()
            sharedLocationManager.desiredAccuracy = CLLocationAccuracy(100.0)
            sharedLocationManager.delegate = sharedLocationManager
        }
        return sharedLocationManager
    }
    
    func requestLocation(success success: (location: CLLocation) -> Void, failure: (error: NSError) -> Void) {
        // Create and store a Location Request
        let locationRequest = LocationRequest()
        locationRequest.success = success
        locationRequest.failure = failure
        self.locationRequests.append(locationRequest)
        
        // Don't start updating locations if they have already started being updated
        if self.isLoadingLocation {
            return
        } else {
            self.isLoadingLocation = true
        }
        
        // Respond based on authorization status
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            self.requestWhenInUseAuthorization()
        } else {
            failure(error: NSError(domain: "BBFLocationManager", code: 6578, userInfo: [NSLocalizedDescriptionKey: "Location services are not authorized"]))
        }
    }
    
    
    // LocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // Stop updates to process the requests
        self.stopUpdatingLocation()
        
        // Return errors to all the requests
        let copiedRequests = self.locationRequests
        for locationRequest: LocationRequest in copiedRequests {
            // Forward the error
            locationRequest.failure(error: error)
            // Remove the request
            self.removeLocationRequest(locationRequest)
        }
        
        // Restart updates if the requests array has not reached 0
        if self.locationRequests.count != 0 {
            self.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: Array<CLLocation>) {
        // Stop updates to process the requests
        self.stopUpdatingLocation()
        
        // Return success to all requests
        let copiedRequests = self.locationRequests
        for locationRequest: LocationRequest in copiedRequests {
            // Forward the error
            locationRequest.success(location: locations.last!)
            // Remove the request
            self.removeLocationRequest(locationRequest)
        }
        
        // Restart updates if the requests array has not reached 0
        if self.locationRequests.count != 0 {
            self.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.startUpdatingLocation()
        } else {
            // Return errors to all the requests
            let copiedRequests = self.locationRequests
            for locationRequest: LocationRequest in copiedRequests {
                // Forward the error
                locationRequest.failure(error: NSError(domain: "BBFLocationManager", code: 4954, userInfo: [NSLocalizedDescriptionKey: "Location services are not authorized"]))
                // Remove the request
                self.removeLocationRequest(locationRequest)
            }
        }
    }
    
    private func removeLocationRequest(locationRequest: LocationRequest) {
        // Remove the element from the location request array
        if let index = self.locationRequests.indexOf(locationRequest) {
            self.locationRequests.removeAtIndex(index)
        }
        
        // If the requests array has reached 0, stop updating
        if self.locationRequests.count == 0 {
            self.stopUpdatingLocation()
            self.isLoadingLocation = false
        }
    }
}