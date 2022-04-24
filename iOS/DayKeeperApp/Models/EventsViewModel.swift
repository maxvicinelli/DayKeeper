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
    
    
    func iCalSync() -> Void {
        
        
        events = [Event]()
        var dbManualEvents = [Event]()
        var dbiCalEvents = [Event]()
        var iCalEvents = [Event]()
        
        var dbEventsToDelete = [Event]()
        var eventsToUpdate = [Event]()
        var eventsToAdd = [Event]()
        
        // get events from DB first
        print("getting db events...")
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            
            let query = realm.objects(Event.self)
            for e in query.where { $0.CreationMethod == iCalCreation } {
                dbiCalEvents.append(e)
            }
            for e in query.where { $0.CreationMethod == ManualCreation } {
                dbManualEvents.append(e)
            }
        }
        
        print("db ical: ")
        print(dbiCalEvents)
        print("db manual: ")
        print(dbManualEvents)
        
        // then, check events in the iCal event store
        print("dbevents done, getting ical")
        let eventStore = EKEventStore()
        for e in dbiCalEvents {
            (eventStore.event(withIdentifier: e._id) == nil ? dbEventsToDelete.append(e) : eventsToUpdate.append(e))
        }
        
        print("getting events from store...")
        let calendars = eventStore.calendars(for: .event)
        let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: calendars)
        let eventsFromStore = eventStore.events(matching: predicate)
        
        for e in eventsFromStore {
            let newCat = Category()
            newCat.Description = "Test more"
            newCat.UserId = userid
            newCat.Cadence = "Weekly"
            
            let newEvent = Event()
            newEvent._id = e.eventIdentifier!
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
            
            iCalEvents.append(newEvent)
        }

        print("ical")
        print(iCalEvents)
        
        print("events to update before checking db and ical")
        print(eventsToUpdate)
        
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            for e in iCalEvents {
                (realm.object(ofType: Event.self, forPrimaryKey: e._id) == nil ? eventsToAdd.append(e) : (eventsToUpdate.contains {$0._id == e._id} ? print("nothing to do") : eventsToUpdate.append(e)) )
            }
        }
        
        print("trying to update realm now...")
        print("events tba: ")
        print(eventsToAdd)
        
        print ("events to update: ")
        print(eventsToUpdate)
        
        print("events to be deleted: ")
        print(dbEventsToDelete)
        
        for e in dbEventsToDelete {
            dbiCalEvents.removeAll(where: {$0._id == e._id})
            dbManualEvents.removeAll(where: {$0._id == e._id})
        }
        
        self.deleteFromRealm(eventsToDelete: dbEventsToDelete)
        dbEventsToDelete.removeAll()
        print("no err yet1")
        print("no err yet2")
        self.updateInRealm(eventsToUpdate: eventsToUpdate)
        print("no err yet3")
        
        
        self.events.append(contentsOf: eventsToAdd)
        print("no err yet4")
        self.events.append(contentsOf: eventsToUpdate)
        print("no err yet5")
        self.sendToRealm()
        print("no err yet6")
        self.events.append(contentsOf: dbManualEvents)
        print("no err yet7")
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
                    print(e.eventIdentifier!)
                    let newCat = Category()
                    newCat.Description = "Test more"
                    newCat.UserId = userid
                    newCat.Cadence = "Weekly"
                    
                    
    //            eventsFromStore.forEach() { e in
                    let newEvent = Event()
                    newEvent._id = e.eventIdentifier!
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
    }
    
    func loadFromDB() -> Void {
//        var events = [Event]()
//        loadFromiCal(registering: true)
        if let app = app {
            DispatchQueue.main.async {
                let user = app.currentUser
                let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
                
                let query = realm.objects(Event.self)
                print("here is what we got")
                print(query)
                for e in query {
                    self.events.append(e)
//                    if e.CreationMethod == ManualCreation {
//                        events.append(e)
//                    } else if e.CreationMethod == iCalCreation {
//                        try! realm.write {
//                            realm.delete(e)
//                        }
//                    }
                }
        
//                self.events.append(contentsOf: events)
            }
        }
    }
    
    func sendToRealm() -> Void {
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            
            do {
                try! realm.write {
                    realm.add(self.events)
                    print("send to realm was a success!")
                }
            } catch {
                print("couldn't send to realm")
            }
        }
    }
    
    func incrementOnTime(delta: Int, event: Event) {
        // delta = 1 for late, -1 for early 
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            try! realm.write {
                event.OnTime += delta
            }
        }
    }
    
    func updateInRealm(eventsToUpdate: [Event]) -> Void {
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            try! realm.write {
                realm.add(eventsToUpdate, update: .modified)
            }
        }
    }
    
    func deleteFromRealm(eventsToDelete: [Event]) -> Void {
        print("deleting")
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            try! realm.write {
                realm.delete(eventsToDelete)
//                self.events.removeAll(where: self.events.contains(_:))
            }
        }
        print("deleted")
        print(self.events)
    }
}
