import Foundation
import CoreLocation
import AFNetworking

let APIEndPoint = "http://brewge-api.jonathanhooper.net/v1/businesses"

var sharedAPIClient: APIClient!

class APIClient: AFHTTPRequestOperationManager {
    
    class func sharedClient() -> APIClient {
        if sharedAPIClient != nil {
            return sharedAPIClient
        } else {
            sharedAPIClient = APIClient()
            return sharedAPIClient
        }
    }
    
    func loadBusinessData(success success: (businesses: BusinessCollection) -> Void, failure: (error: NSError!) -> Void) {
        // Use AFNetworking to load the data from the API
        self.GET(APIEndPoint, parameters:nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            // Load the data from the response. Go to the failure block if it can't be loaded
            let businessDataArray: Array<(Dictionary<String, AnyObject>)>! = response as? Array<(Dictionary<String, AnyObject>)>
            if businessDataArray == nil {
                failure(error: NSError(domain: "API Client", code: 5624, userInfo: [NSLocalizedDescriptionKey: "Unable to load response from Open Data"]))
                return
            }
            
            // Load the bathrooms from the response data
            let businesses = BusinessCollection()
            for businessData in businessDataArray {
                if let business = self.createBusinessithData(businessData) {
                    businesses.append(business)
                }
            }
            
            // Go to the success block with the bathrooms
            success(businesses: businesses)
        },
        failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            // If AFNetworking fails forward the error
            failure(error: error)
        })
    }
    
    private func createBusinessithData(data: Dictionary<String, AnyObject>) -> Business? {
        // Get the name and geolocation data from the API response data
        let name: String? = data["name"] as? String
        let latitude: Double? = data["latitude"] as? Double
        let longitude: Double? = data["longitude"] as? Double
        let address: String? = data["address"] as? String
        
        // Create the CLLocation
        var location: CLLocation?
        if let latitude = latitude, longitude = longitude {
            location = CLLocation(latitude: latitude, longitude: longitude)
        }
        
        // Create and return the business or nil
        if name != nil && address != nil && location != nil {
            return Business(name: name!, address: address!, location: location!)
        } else {
            return nil
        }
    }
    
}