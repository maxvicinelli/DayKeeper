//
//  MapView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 5/18/22.
//

import MapKit
import SwiftUI

struct MapView: View {
    // temporary -- Garret will change this
    @StateObject private var mapAPI = MapAPI()
    @State private var text = ""
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.704540, longitude: -72.288986), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var body: some View {
        VStack {
            TextField("Enter an address", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            Button("Find Address") {
                mapAPI.getLocation(address: text, delta: 0.01)
            }
        }
        Map(coordinateRegion: $mapAPI.region, annotationItems: mapAPI.locations) {
            location in
            MapMarker(coordinate: location.coordinate, tint: .blue)
        }
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
