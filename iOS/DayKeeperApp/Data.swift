//
//  Data.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/6/22.
//

import Foundation
import EventKit
import RealmSwift

final class Data : ObservableObject {
    @Published var loadedEvents : [Event] = dummyEvents()//loadFromiCal()
}

func loadFromiCal() -> [Event] {
    let eventStore = EKEventStore()
    var events = [Event]()
    print("got event store")
    
    eventStore.requestAccess(to: .event) { (granted, error) in
        if granted {
            
            print("granted!")
            let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
            let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: nil)
            
            print("lets get events")
            
            //return eventStore.events(matching: predicate)
            let eventsFromStore = eventStore.events(matching: predicate)
            print(eventsFromStore)
            eventsFromStore.forEach() { e in
                let newEvent = Event()
                newEvent.UserId = ObjectId()
                newEvent.Category = "Test"
                newEvent.Title = e.title
                newEvent.Description = e.description
                newEvent.StartDate = e.startDate
                newEvent.EndDate = e.endDate
                newEvent.Recurrence = "Daily"
                newEvent.OnTime = -1
                newEvent.NotifBefore = -1
                newEvent.PreEvents = List<PreEvent>()
                
                events.append(newEvent)
            }

        }
    }
    
    return events
}

func dummyEvents() -> [Event] {
    let randomAdjectives = [
        "fluffy", "classy", "bumpy", "bizarre", "wiggly", "quick", "sudden",
        "acoustic", "smiling", "dispensable", "foreign", "shaky", "purple", "keen",
        "aberrant", "disastrous", "vague", "squealing", "ad hoc", "sweet"
    ]
    
    let randomNouns = [
        "floor", "monitor", "hair tie", "puddle", "hair brush", "bread",
        "cinder block", "glass", "ring", "twister", "coasters", "fridge",
        "toe ring", "bracelet", "cabinet", "nail file", "plate", "lace",
        "cork", "mouse pad"
    ]
    
    let randomNums = [ 1, 2, 3]

    var events = [Event]()
    
    for _ in 0...10 {
        let newEvent = Event()
        newEvent.UserId = ObjectId()
        newEvent.Category = "Test"
        newEvent.Title = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
        newEvent.Description = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
        newEvent.StartDate = Date(timeIntervalSinceNow: 0)
        newEvent.EndDate = Date(timeIntervalSinceNow:3600 * 24 * 7)
        newEvent.Recurrence = "Daily"
        newEvent.OnTime = -1
        newEvent.NotifBefore = -1
        newEvent.PreEvents = List<PreEvent>()
        for _ in 0...randomNums.randomElement()! {
            let newPre = PreEvent()
            newPre.EventId = newEvent.Id
            newPre.NotifBefore = -1
            newPre.Done = true
            newPre.Description = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
            newEvent.PreEvents.append(newPre)
        }
        events.append(newEvent)
    }
    
    return events
}
