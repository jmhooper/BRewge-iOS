import UIKit

public class AlertController: UIAlertController {
    
    public class func errorFetchingDataController() -> UIAlertController {
        let controller = UIAlertController(
            title: "An Error Occured",
            message: "An error occured while trying to fetch data.",
            preferredStyle: .Alert
        )
        controller.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: nil
        ))
        return controller
    }
    
    public class func openAppleMapsForBusinessController(business: Business) -> UIAlertController {
        let message = String(format: "Open %@ in Maps?", arguments: [business.name])
        let controller = UIAlertController(
            title: business.name,
            message: message,
            preferredStyle: .Alert
        )
        controller.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil
            ))
        controller.addAction(UIAlertAction(
            title: "Yes",
            style: .Default,
            handler: { (action: UIAlertAction!) -> Void in
                business.openInAppleMaps()
            }
        ))
        return controller
    }
    
    public class func aboutBrewgeController() -> UIAlertController {
        let controller = UIAlertController(
            title: "About BRewge",
            message: "BRewge queries Baton Rouge's Open Data API for open businesses with a liquor license and displays them on a map.\n\nFor comments or feature requests find me on Twitter: @Jonathan_Hooper",
            preferredStyle: .Alert
        )
        controller.addAction(UIAlertAction(
            title: "That's cool I guess.",
            style: .Default,
            handler: nil
        ))
        controller.addAction(UIAlertAction(
            title: "@Jonathan_Hooper",
            style: .Default,
            handler: { (action) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "http://twitter.com/jonathan_hooper")!)
            }
        ))
        return controller
    }
    
}