//
//  ViewController.swift
//  Brewge
//
//  Created by Jonathan Hooper on 8/11/15.
//  Copyright (c) 2015 JonathanHooper. All rights reserved.
//

import UIKit
import MapKit

public class BusinessesMapTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet public var businessesMapTableView: BusinessesMapTableView!
    
    // MARK: Instance Variable
    
    public var locationManager: CLLocationManager {
        if _locationManager == nil {
            _locationManager = CLLocationManager()
            _locationManager!.desiredAccuracy = CLLocationAccuracy(100)
            _locationManager!.delegate = self
        }
        return _locationManager!
    }
    private var _locationManager: CLLocationManager?
    
    private var businesses = BusinessCollection()
    
    // MARK: View Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        businessesMapTableView.styleSubviews()
        businessesMapTableView.mapView.delegate = self
        attemptToDisplayUserLocation()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadBusinesses()
        businessesMapTableView.panMapToBatonRouge()
    }
    
    // MARK: Business Loading
    
    private func loadBusinesses() {
        businessesMapTableView.activityIndicatorView.startAnimating()
        APIClient.sharedClient().loadBusinessData(
            success: { (businesses: BusinessCollection) -> Void in
                self.sortBusinesses(businesses)
            },
            failure: { (error: NSError!) in
                self.failToLoadBusinesses()
            }
        )
    }
    
    private func sortBusinesses(businesses: BusinessCollection) {
        LocationManager.sharedManager().requestLocation(
            success: { (location: CLLocation) -> Void in
                businesses.sortForLocation(location)
                self.successfullyLoadBusinesses(businesses)
            }, failure: { (error: NSError) -> Void in
                businesses.sortByName()
                self.successfullyLoadBusinesses(businesses)
            }
        )
    }
    
    private func successfullyLoadBusinesses(businesses: BusinessCollection) {
        businessesMapTableView.activityIndicatorView.stopAnimating()
        self.businesses = businesses
        businessesMapTableView.tableView.reloadData()
        businessesMapTableView.updateMapAnnotations(self.businesses.businesses)
    }
    
    private func failToLoadBusinesses() {
        businessesMapTableView.activityIndicatorView.stopAnimating()
        presentViewController(
            AlertController.errorFetchingDataController(),
            animated: true,
            completion: nil
        )
    }
    
    // MARK: MapKit
    
    public func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let business = view.annotation as? Business {
            if let index = businesses.businesses.indexOf(business) {
                businessesMapTableView.tableView.scrollToRowAtIndexPath(
                    NSIndexPath(forItem: index, inSection: 0),
                    atScrollPosition: .Top,
                    animated: true
                )
            }
        }
    }
    
    // MARK: Location Management
    
    private func attemptToDisplayUserLocation() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            businessesMapTableView.mapView.showsUserLocation = true
        }
    }
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            businessesMapTableView.mapView.showsUserLocation = true
        }
    }
    
    // MARK: Actions
    
    @IBAction public func refreshButtonPressed(sender: AnyObject!) {
        loadBusinesses()
    }
    
    @IBAction public func aboutButtonPressed(sender: AnyObject!) {
        presentViewController(
            AlertController.aboutBrewgeController(),
            animated: true,
            completion: nil
        )
    }
    
    // MARK: Table View Methods
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel!.text = businesses[indexPath.row].name
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let business: Business = businesses[indexPath.row]
        showMapsAppAlertForBusiness(business)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func showMapsAppAlertForBusiness(business: Business) {
        presentViewController(
            AlertController.openAppleMapsForBusinessController(business),
            animated: true,
            completion: nil
        )
    }

}

