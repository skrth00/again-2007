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
    var mapView: MKMapView!
    
    // locationManager
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    // map etc...
    let regionRadius: CLLocationDistance = 500
    
    var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
        updateLocation()
        
        
    }
    
    
    func viewInit(){
        mapView = MKMapView()
        mapView.rframe(x: 0, y: 0, width: 375, height: 667)
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        self.view.addSubview(mapView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(dragAction))
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleGesture.numberOfTapsRequired = 2
        
        homeButton = UIButton()
        homeButton.rframe(x: 0, y: 617, width: 50, height: 50)
        homeButton.setButton(imageName: "home", targetController: self, action: #selector(homeButtonAction), self.view)
        homeButton.addGestureRecognizer(gesture)
        homeButton.addGestureRecognizer(doubleGesture)
        homeButton.isUserInteractionEnabled = true
        
        homeButton.layer.masksToBounds = true
        homeButton.layer.cornerRadius = 25.multiplyWidthRatio()
        
    }
    
    func updateLocation(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func homeButtonAction(){
        self.dismiss(animated: false, completion: nil)
    }
    
    func dragAction(gesture: UIPanGestureRecognizer){
        let loc = gesture.location(in: self.view)
        self.homeButton.center = loc
    }
    

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print(location!.coordinate.latitude)
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

