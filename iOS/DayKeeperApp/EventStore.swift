//
//  EventStore.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/15/22.
//

import Foundation
import EventKit

class EventStore {
    let store : EKEventStore
    let events : [Event]
    init() {
        store = EKEventStore()
        events = loadFromiCal(eventStore: store)
    }
    
    func getEvents() -> [Event] {
        return events
    }
}
