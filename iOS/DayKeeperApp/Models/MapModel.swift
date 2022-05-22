//
//  MapModel.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 5/18/22.
//  tutorial: https://www.youtube.com/watch?v=dJ6f2o92tKg

import Foundation
import MapKit

struct Address: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let latitude, longitude: Double
    let name: String?
    let label: String?      // do we want label too?
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class MapAPI: ObservableObject {
    private let BASE_URL = "http://api.positionstack.com/v1/forward"   
    private let API_KEY = "40fdcb0a206dc5059edfde3b6d548a76"
    
    @Published var region: MKCoordinateRegion
    @Published var coordinates = []
    @Published var locations: [Location] = []
    
    init() {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.704540, longitude: -72.288986), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.locations.insert(Location(name: "Pin", coordinate: CLLocationCoordinate2D(latitude: 43.704540, longitude: -72.288986)), at: 0)
    }
    
    func setMapLocation(locationName: String, latitude: Double, longitude: Double) {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.locations.removeAll()
        self.locations.insert(Location(name: locationName, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)), at: 0)
    }
    func getLocation(address: String, delta: Double) {
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")   // to make address work with API
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)"
        
        guard let url = URL(string: url_string) else {
                print("Invalid URL")
                return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }
            
            if newCoordinates.data.isEmpty {
                print("Could not find the address...")
                return
            }
            
            DispatchQueue.main.async {
                let details = newCoordinates.data[0]
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                let label = details.label       // maybe label not needed?
                
                self.coordinates = [lat, lon]
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                
                let new_location = Location(name: name ?? "Pin", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                
                self.locations.removeAll()
                self.locations.insert(new_location, at: 0)
                
                print("Successfully loaded the location!")
            }
        }
        .resume()
    }
    
}
