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
   public var locationManager = CLLocationManager()
   public var location: CLLocation?
        
    
    func authorizelocationstates(){
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                location = locationManager.location
                print("DEBUG: Driver coodinates are \(location!)")
            }
            else{
                // Note : This function is overlap permission
                  locationManager.requestWhenInUseAuthorization()
                  authorizelocationstates()
            }
        }
       
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locationManager = manager
            // Only called when variable have location data
            authorizelocationstates()
        }
        
    
    override init() {
            super.init()

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            // Get Location Permission one time only
            locationManager.requestWhenInUseAuthorization()
            // Need to update location and get location data in locationManager object with delegate
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()

        }

    }
    








    
    
    //    override init() {
    //        super.init()
    //
    //        locationManager = CLLocationManager()
    //        locationManager.delegate = self
    //    }
    




    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestAlwaysAuthorization()
//        }
//
//        func locationManager(_ manager: CLLocationManager,
//                             didUpdateLocations locations: [CLLocation]) {
//            print("DEBUG: Driver location is \(self.locationManager?.location)")
//        }
//    }
//}
