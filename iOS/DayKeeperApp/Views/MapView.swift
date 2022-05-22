//
//  MapView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 5/18/22.
//

import MapKit
import SwiftUI
import RealmSwift

struct MapView: View {
    // temporary -- Garret will change this
    @State private var text = ""
    var event: Event
    @StateObject private var mapAPI = MapAPI()
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.704540, longitude: -72.288986), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    var body: some View {
        VStack {
            TextField("Enter an address", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            Button(action: {
                mapAPI.getLocation(address: text, delta: 0.01)
            }, label: {
                Text("Find Address")
                    .foregroundColor(.white)
            } )
            Button(action:{
                    print("values we are about to save into the event:", mapAPI.coordinates[0], mapAPI.coordinates[1], mapAPI.locations[0].name)
        //            print("new category is:", new_category)
        //            print("userid is:", userid)
                    if let app = app {
                        let user = app.currentUser
                        let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
                        try! realm.write{
                            event.Latitude = mapAPI.coordinates[0] as! Double
                            event.Longitude = mapAPI.coordinates[1] as! Double
                            event.Location = mapAPI.locations[0].name
                            realm.add(event, update: .modified)
        //                    print("adding event to realm with this new category:", event.Category?.Title)
                        }
                    }
                    postEvent(event: event, updating: true)
                   }, label: {
                       Text("Done")
                           .foregroundColor(.white)
                
            })
        Map(coordinateRegion: $mapAPI.region, annotationItems: mapAPI.locations) {
            location in
            MapMarker(coordinate: location.coordinate, tint: .blue)
        }
        .ignoresSafeArea()
        .onAppear(perform: {mapAPI.setMapLocation(locationName: event.Location, latitude: event.Latitude, longitude: event.Longitude)})
    }
        .background(Color(red:0.436, green: 0.558, blue: 0.925))
}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(event: Event())
    }
}
