//
//  LocationManager.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 5/18/22.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

final class LocationManager: ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
        } else {
            print("Show an alert letting them know location services is off and to go turn it on in settings")
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted likely due to parental controls")
            case .denied:
                print("You have denied this app location permission. Go into settings to change it.")
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
        }

    }
    
    
}
