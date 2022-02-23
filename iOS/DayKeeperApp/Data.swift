//
//  Data.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/6/22.
//

import Foundation
import EventKit
import RealmSwift
import os
import SwiftUI

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
let userid = UUID()

final class Data : ObservableObject {
    @Published var loadedEvents : EventsViewModel = dummyEvents()//loadFromiCal()
}

// adapted from https://techblog.travelhackfun.com/2020/10/09/retrieving-ios-calendar-event-with-eventkit/
func authorizeEK(eventStore: EKEventStore) -> Bool {
    var accessGranted : Bool = false
    eventStore.requestAccess(to: .event) { (granted, error ) in
        accessGranted = granted
    }
    return accessGranted
}

func getEventsFromiCal(eventStore : EKEventStore) -> [Event] {
    var events = [Event]()
    let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
    let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: nil)
    
    print("-----------------------------")
    
    print(eventStore.events(matching: predicate))
    print("-----------------------------")
    
    let eventsFromStore = eventStore.events(matching: predicate)
    let newCat = Category()
    newCat.Title = "Test"
    newCat.Description = "Test more"
    newCat.UserId = userid
    newCat.Cadence = "Weekly"
    
    let taskCat = Category()
    taskCat.Title = "Task category"
    taskCat.Description = "Task test"
    taskCat.UserId = userid
    taskCat.Cadence = "NEVER"
    for e in eventsFromStore {
        let newEvent = Event()
        newEvent.UserId = userid
        newEvent.Category = newCat
        newEvent.Title = e.title
        newEvent.Description = e.description
        newEvent.StartDate = e.startDate
        newEvent.EndDate = e.endDate
        newEvent.OnTime = -1
        newEvent.NotifBefore = -1
        newEvent.Tasks = RealmSwift.List<Event>()
        for _ in 0...randomNums.randomElement()! {
            let newTask = Event()
            newTask.UserId = userid
            newTask.Category = taskCat
            newTask.Title = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
            newTask.Description = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
            newTask.NotifBefore = -1
            newTask.OnTime = -1
            newEvent.Tasks?.append(newTask)
        }
        events.append(newEvent)
    }
    return events
}

func loadFromiCal() -> [Event] {
//    let eventsVM = EventsViewModel()
    
    let eventStore = EKEventStore()
    
    var events = [Event]()
    eventStore.requestAccess(to: .event) { (granted, error) in
        if granted {
            
            let calendars = eventStore.calendars(for: .event)
            
            print("granted!")
            let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
            let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: calendars)
            
            print("lets get events")
            //return eventStore.events(matching: predicate)
            let eventsFromStore = eventStore.events(matching: predicate)
            
            print("here are our events from store")
            print(eventsFromStore)
            
            
            let newCat = Category()
            newCat.Title = "Test"
            newCat.Description = "Test more"
            newCat.UserId = userid
            newCat.Cadence = "Weekly"
            
            let taskCat = Category()
            taskCat.Title = "Task category"
            taskCat.Description = "Task test"
            taskCat.UserId = userid
            taskCat.Cadence = "NEVER"
            for e in eventsFromStore {
//            eventsFromStore.forEach() { e in
                print("-------------------------")
                print("iteration: ")
                print("e")
                let newEvent = Event()
                newEvent.UserId = userid
                newEvent.Category = newCat
                newEvent.Title = e.title
                newEvent.Description = "desc"
                newEvent.StartDate = e.startDate
                newEvent.EndDate = e.endDate
                newEvent.OnTime = -1
                newEvent.NotifBefore = -1
                newEvent.Tasks = RealmSwift.List<Event>()
                for _ in 0...randomNums.randomElement()! {
                    let newTask = Event()
                    newTask.UserId = userid
                    newTask.Category = taskCat
                    newTask.Title = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
                    newTask.Description = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
                    newTask.NotifBefore = -1
                    newTask.OnTime = -1
                    newEvent.Tasks?.append(newTask)
                }
                events.append(newEvent)
                print("got a new guy in events!")
                print(events)
            }
            // eventsVM.events = events
//            DispatchQueue.main.async {
//                eventsVM.events = events
//                print("yooooo we finished")
//                print(eventsVM.events)
//            }
            
        }
        else {
            print("no cal access")
        }
    }
    print("finished load from iCal with events: ")
    print(events)
    return events
}

func dummyEvents() -> EventsViewModel {
    let eventsVM = EventsViewModel()
    var events = [Event]()
    let newCat = Category()
    newCat._id = UUID()
    newCat.Title = "Demo test"
    newCat.Description = "Demo test"
    newCat.UserId = userid
    newCat.Cadence = "Weekly"
    
    for _ in 0...10 {
        //let userid = UUID()//uuidString: "620415ea8833dd465fb6f1f2")!
    
        let newEvent = Event()
        newEvent._id = UUID()
        newEvent.UserId = userid
        newEvent.Category = newCat
        newEvent.Title = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
        newEvent.Description = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
        newEvent.StartDate = Date(timeIntervalSinceNow: 0)
        newEvent.EndDate = Date(timeIntervalSinceNow: 24 * 3600 * 7)
        newEvent.OnTime = -1
        newEvent.NotifBefore = -1
        newEvent.Tasks = RealmSwift.List<Event>()
        for _ in 0...randomNums.randomElement()! {
            let newTask = Event()
            newTask.UserId = userid
            newTask.Title = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
            newTask.Description = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
            newTask.NotifBefore = -1
            newTask.OnTime = -1
            newTask.StartDate = Date(timeIntervalSince1970: 0)
            newTask.EndDate = Date(timeIntervalSince1970: 0)
            newEvent.Tasks?.append(newTask)
        }
        events.append(newEvent)
    }
    
    eventsVM.events = events
    return eventsVM
}

func sendToRealm(events: [Event]) -> Void {
//    print(events)
    if let app = app {
        let user = app.currentUser
        let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
        try! realm.write {
            realm.add(events)
        }
    }
}
