//
//  AppleMapVC.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 26..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AppleMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // mapKit
    @IBOutlet var mapView: MKMapView!
    
    // locationManager
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    // map etc...
    let regionRadius: CLLocationDistance = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation()
    }
    
    
    func updateLocation(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let initialLocation = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        centerMapOnLocation(location: initialLocation)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }
        
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

