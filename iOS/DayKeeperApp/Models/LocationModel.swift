//
//  LocationModel.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 5/22/22.
//  Eventually this file will be used to track the user's location in the background to tell how far from next event they are

import Foundation
import CoreLocationUI
import CoreLocation
import MapKit
import SwiftUI




import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
    
    
    
    
}

func getDrivingTime(event: Event, completion: @escaping(Double?) -> Void){
    let user_location = get_user_location()
    
    // location 1 is static for now -- just Dartmouth's address
    let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: user_location.latitude, longitude: user_location.longitude))
    // location 2 is the location of the next event
    let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: event.Latitude, longitude: event.Longitude))
    
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: p1)
    request.destination = MKMapItem(placemark: p2)
    request.transportType = .automobile
    
        // maybe dont need?
    let directions = MKDirections(request: request)
    directions.calculate { response, error in
//        print("inside calculate statement")
        guard let routes = response?.routes.first else {return}
        let travelTime = routes.expectedTravelTime
        completion(travelTime)
    }
}

func get_user_location() -> CLLocationCoordinate2D{
    @ObservedObject var locationManager = LocationManager()
    //  locationViewModel.requestPermission()
    print("LATITUDE")
    print(String(locationManager.lastLocation?.coordinate.latitude ?? 0))
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    if locationManager.lastLocation != nil{
    return locationManager.lastLocation!.coordinate
    }
    
    else{
        
        return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    }
    
}

