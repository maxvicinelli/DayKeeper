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

final class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.704540, longitude: -72.288986), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

    let locationManager = CLLocationManager()

    func requestAllowAlwaysLocationPermission() {
        locationManager.requestLocation()

    }

}


func getDrivingTime(event: Event, completion: @escaping(Double?) -> Void){
    // location 1 is static for now -- just Dartmouth's address
    let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 43.704540, longitude: -72.288986))
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
