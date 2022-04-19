//
//  EventsViewModel.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/16/22.
//

import Foundation
import EventKit
import RealmSwift

final class EventsViewModel : ObservableObject {
    @Published var events : [Event] = [Event]()
    
    var actionNotifManager = ActionNotifManager()
    
    
    func loadEvents(registering: Bool) -> Void {
//        var oldEvents = getEventsFromDb()
//
//        let iCalEvents = loadFromiCal(registering: false)
//        var newEvents = [Event]()
//
//        // loop
//
//
//        for event in self.events {
//            if
//        }
//        self.events = getEventsFromDb()
        var oldEvents = getEventsFromDb()
        print("db: ")
        print(oldEvents)
        loadFromiCal(registering: false)
        print("loading new from ical...")
        self.events.append(contentsOf: oldEvents)
        print(self.events)
        
    }
    
    
    func loadFromiCal(registering: Bool) -> Void {
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
                
                
                
                
                let taskCat = Category()
                taskCat.Title = "Task category"
                taskCat.Description = "Task test"
                taskCat.UserId = userid
                taskCat.Cadence = "NEVER"
                for e in eventsFromStore {
                    let newCat = Category()
                    newCat.Description = "Test more"
                    newCat.UserId = userid
                    newCat.Cadence = "Weekly"
                    
                    
    //            eventsFromStore.forEach() { e in
                    let newEvent = Event()
                    newEvent.UserId = userid
                    newCat.Title = e.calendar.title
                    newEvent.Category = newCat
                    newEvent.Title = e.title
                    newEvent.Description = "desc"
                    newEvent.StartDate = e.startDate
                    newEvent.EndDate = e.endDate
                    newEvent.OnTime = -1
                    newEvent.NotifBefore = -1
                    newEvent.CreationMethod = iCalCreation
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
//                    print("got a new guy in events!")
//                    print(events)
                }
                 
                if registering {
                    DispatchQueue.main.async {
                        self.events.append(contentsOf: events)
                        print("here are our events: ")
                        print(self.events)
                        print("now were done")
                        self.sendToRealm()
                        self.actionNotifManager.createStatusUpdateNotifs()
                    }
                } else {
                    self.events.append(contentsOf: events)
                }
                
            }
        }
        print("now calling actionNotificationManager")
        
    }
    
    func loadFromDB() -> Void {
        var events = [Event]()
        loadFromiCal(registering: true)
        if let app = app {
            DispatchQueue.main.async {
                let user = app.currentUser
                let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
                
                let query = realm.objects(Event.self)
                print("here is what we got")
                print(query)
                for e in query {
                    events.append(e)
                }
        
                self.events.append(contentsOf: events)
            }
        }
    }
    
    func sendToRealm() -> Void {
    //    print(events)
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            try! realm.write {
                realm.add(self.events)
            }
        }
    }
    //    print(events)
    func combineDBandiCal() -> Void {
        var dbEvents = [Event]()//loadFromDBArray()
        print("db: ")
        print(dbEvents)
//        loadFromiCal(registering: false)
//        var iCalEvents = loadFromiCal(registering: false)
        print("vm: ")
        print(self.events)
        var manualEvents = self.events.filter { event in
            (event.CreationMethod == ManualCreation)
        }
        print("manual: ")
        print(manualEvents)
        print("db :")
        var iCalEvents = self.events.filter { event in
            (event.CreationMethod == iCalCreation)
        }
        print(iCalEvents)
        
//        DispatchQueue.main.async {
//            print("combined :")
//            var combined = iCalEvents.append(contentsOf: manualEvents)
//            print(combined)
////            self.events = combined
//            print("here are our events: ")
//            print(self.events)
//            print("now were done")
////            sendToRealm(events: self.events)
////            self.actionNotifManager.createStatusUpdateNotifs()
//        }
    }
    
    
//
//    func updateEvents() -> Void {
//
//        print("----------------------------")
//
//        self.events = getEventsFromDb()
//    }
//    override func viewWillAppear(_ animated : Bool) {
//        events = getEventsFromDb().events
//        super.viewWillAppear(animated)
//        print("test")
//    }
}
