//
//  EventView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/4/22.
//

import SwiftUI
import RealmSwift
import EventKit

struct EventsView: View {
    @ObservedObject var app: RealmSwift.App
    @ObservedObject var eventsVM : EventsViewModel
    var eventStore = EKEventStore()

//    mutating func helper() {
//        self.eventsVM = getEventsFromDb()
//    }

//    override func viewWillAppear(_ animated : Bool) {
//        self.eventsVM = getEventsFromDb()
//        super.viewWillAppear(animated)
//        print("test")
//    }
//
    var body: some View {
        NavigationView {
            List {
                ForEach(eventsVM.events) { event in
                    NavigationLink {
                        EventRow(event: event)
                    } label:
                    {
                        Text(event.Title)
                        .onAppear(perform: {eventsVM.update()})
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                Button("Send to Realm", action: { sendToRealm(events: eventsVM.events) })
            }
        }
    }
}


struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(app: app!, eventsVM: dummyEvents())//, events: dummyEvents())//loadFromiCal(eventStore: EKEventStore()))
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

