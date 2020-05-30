//
//  LocationHandler.swift
//  Bus Tracker
//
//  Created by Sadat Safuan on 5/13/20.
//  Copyright © 2020 Sadat Safuan. All rights reserved.
//


import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHandler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        
        func locationManager(_ manager: CLLocationManager,
                             didUpdateLocations locations: [CLLocation]) {
            print("DEBUG: Driver location is \(self.locationManager?.location)")
        }
    }
}
