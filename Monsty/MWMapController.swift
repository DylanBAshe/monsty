//
//  MWMapController.swift
//  Monsty!
//
//  Created by dyashe on 8/29/16.
//  Copyright © 2016 monstyware. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation
import MapKit

let mapViewDidFinishRenderingMapKey = "com.monstyware.monsty.mapViewDidFinishRenderingMapKey"

class MWMapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
 
    @IBOutlet weak var mapView: MKMapView!
    
    var updatingLocation:Bool = true
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
        }
        
        mapView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (updatingLocation) {
            locationManager.stopUpdatingLocation()
            updatingLocation = false
        }
        let location = locations.last as CLLocation!
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: mapViewDidFinishRenderingMapKey), object:nil)
    }
    
    func gotoName(_ name: String, completionHandler:@escaping (_ result: NSError)->() ) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = name
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start {(response, error) in
            guard let response = response else {
                completionHandler(error! as NSError)
                return
            }
            
            let newRecordAddress = (response.mapItems[0]).placemark
            let center = CLLocationCoordinate2D(latitude: newRecordAddress.location!.coordinate.latitude, longitude: newRecordAddress.location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
}
