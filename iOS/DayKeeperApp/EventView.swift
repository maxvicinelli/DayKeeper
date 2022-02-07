//
//  EventView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/4/22.
//

import SwiftUI
import RealmSwift

struct EventView: View {
//    @ObservedRealmObject var events: [Event]
    var events: [Event]
    //@ObservedRealmObject var event: Event
    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                    NavigationLink {
                        EventRow(event: event)
                    } label:
                    {
                        Text(event.Title)
                    }
                }
            }
            .navigationTitle("Events")
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(events: dummyEvents())
        //EventView()
    }
}
