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
        businessesMapTableView.mapView.delegate = self
        attemptToDisplayUserLocation()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadBusinesses()
        businessesMapTableView.panMapToInitialLocation()
    }
    
    // MARK: Business Loading
    
    private func loadBusinesses() {
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
        self.businesses = businesses
        businessesMapTableView.tableView.reloadData()
        businessesMapTableView.updateMapAnnotations(self.businesses.businesses)
        businessesMapTableView.tableView.setContentOffset(CGPointZero, animated: true)
        businessesMapTableView.panMapToInitialLocation()
    }
    
    private func failToLoadBusinesses() {
        presentViewController(
            AlertController.errorFetchingDataController(),
            animated: true,
            completion: nil
        )
        businessesMapTableView.tableView.setContentOffset(CGPointZero, animated: true)
        businessesMapTableView.panMapToInitialLocation()
    }
    
    // MARK: MapKit
    
    public func mapView(
        mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation
    ) -> MKAnnotationView? {
        if let business = annotation as? Business {
            let annotationView = BusinessAnnotationView(business: business)
            return annotationView
        } else {
            return nil
        }
    }
    
    public func mapView(
        mapView: MKMapView,
        didSelectAnnotationView view: MKAnnotationView
    ) {
        if let annotationView = view as? BusinessAnnotationView {
            scrollTableViewToBusiness(annotationView.business)
            annotationView.addGestureRecognizer(businessAnnotationTapGestureRecognizer)
        }
    }
    
    public func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if let annotationView = view as? BusinessAnnotationView {
            scrollTableViewToBusiness(annotationView.business)
            annotationView.removeGestureRecognizer(businessAnnotationTapGestureRecognizer)
        }
    }
    
    // MARK: Annotation View Tap Gesture
    
    public var businessAnnotationTapGestureRecognizer: UITapGestureRecognizer {
        if _businessAnnotationTapGestureRecognizer == nil {
            _businessAnnotationTapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: "selectedAnnotationTapped"
            )
        }
        return _businessAnnotationTapGestureRecognizer!
    }
    private var _businessAnnotationTapGestureRecognizer: UITapGestureRecognizer?
    
    public func selectedAnnotationTapped() {
        if let business = businessesMapTableView.mapView.selectedAnnotations.first as? Business {
            showMapsAppAlertForBusiness(business)
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
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        let business = businesses[indexPath.row]
        cell.textLabel!.text = business.name
        cell.detailTextLabel!.text = business.address
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let business: Business = businesses[indexPath.row]
        showMapsAppAlertForBusiness(business)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func scrollTableViewToBusiness(business: Business) {
        if let index = businesses.businesses.indexOf(business) {
            businessesMapTableView.tableView.scrollToRowAtIndexPath(
                NSIndexPath(forItem: index, inSection: 0),
                atScrollPosition: .Top,
                animated: true
            )
        }
    }
    
    // MARK: Alert Controllers
    
    private func showMapsAppAlertForBusiness(business: Business) {
        presentViewController(
            AlertController.openAppleMapsForBusinessController(business),
            animated: true,
            completion: nil
        )
    }

}

