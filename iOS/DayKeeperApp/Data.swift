//
//  Data.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/6/22.
//

import Foundation
import EventKit

final class Data : ObservableObject {
    @Published var loadedEvents : [Event] = loadFromiCal()
}

func loadFromiCal() -> [EKEvent] {
    let eventStore = EKEventStore()
    
    print("got event store")
    
    eventStore.requestAccess(to: .event) { (granted, error) in
        if granted {
            
            print("granted!")
            let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
            let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: nil)
            
            print("lets get events")
            
            //return eventStore.events(matching: predicate)
            let events = eventStore.events(matching: predicate)
            print(events)

        }
    }
    
    return events
}
