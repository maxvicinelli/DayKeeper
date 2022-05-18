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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.704540, longitude: -72.288986), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
