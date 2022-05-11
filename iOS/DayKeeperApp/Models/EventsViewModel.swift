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
    
    func reload() -> Void {
        print("EventsViewModel reload called")
        events = [Event]()
        loadFromDB()
    }
    
    func iCalSync() -> Void {
        print("iCalSync called")
//        print("self.events before removing all:", self.events)
        self.events.removeAll()
//        print("self.events afer removing all:", self.events)
        var dbManualEvents = [Event]()
        var dbiCalEvents = [Event]()
        var iCalEvents = [Event]()
        
        var dbEventsToDelete = [Event]()
        var eventsToUpdate = [Event]()
        var eventsToAdd = [Event]()
                
        // get events from DB first
        // dbiCalEvents holds the events that are in the DB that were pulled from iCal
        // dbManuelEvents holds the events that are in the DB that were created manually
//        print("getting db events...")
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
//
//        print("db ical: ")
//        print(dbiCalEvents)
//        print("db manual: ")
//        print(dbManualEvents)
//
        // then, check events in the iCal event store
//        print("dbevents done, getting ical")
        let eventStore = EKEventStore()
        for e in dbiCalEvents {
            (eventStore.event(withIdentifier: e._id) == nil ? dbEventsToDelete.append(e) : print("nothing to add"))
        }
        
//        print("getting events from store...")
        let calendars = eventStore.calendars(for: .event)
        let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
//        filteredCalendars.append(calendars.first(where: {$0.title == "Calendar"}))
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: calendars.filter{$0.title == "Calendar"})
        let eventsFromStore = eventStore.events(matching: predicate)
        
        
        for e in eventsFromStore {
            let newEvent = Event()
            let category = Category()
            category.Description = "Test more"
            category.UserId = userid
            category.Cadence = "Weekly"
            category.Title = e.calendar.title
            newEvent.Category = category
            newEvent._id = e.eventIdentifier!
            newEvent.UserId = userid
            newEvent.Title = e.title
            newEvent.StartDate = e.startDate
            newEvent.EndDate = e.endDate
            newEvent.CreationMethod = iCalCreation
            newEvent.Tasks = RealmSwift.List<String>()
            newEvent.OnTime = -1
            newEvent.NotifBefore = -1
            newEvent.Description = ""
            
            // Is there a more efficient way of doing this below? Not sure but this works for now -Jonah
            for e_db in dbiCalEvents {
                if e_db._id == e.eventIdentifier || e.title == e_db.Title {
                    newEvent.OnTime = e_db.OnTime
                    newEvent.NotifBefore = e_db.NotifBefore
                    newEvent.Category = e_db.Category
                    newEvent.Description = e_db.Description
                    newEvent.Tasks = e_db.Tasks
                    break
                }
            }
            
            iCalEvents.append(newEvent)
        }

//        print("ical")
//        print(iCalEvents)
//
//        print("events to update before checking db and ical")
//        print(eventsToUpdate)
//
        // Now check to see if events currently in User's iCal are in Realm -- search based on event ID
        // if it is not in Realm, then add event to "eventsToAdd" array
        // if it is in Realm, then add it to the "eventsToUpdate" array (if it is not already in "eventsToUpdate"
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            for e in iCalEvents {
                (realm.object(ofType: Event.self, forPrimaryKey: e._id) == nil ? eventsToAdd.append(e) : (eventsToUpdate.contains {$0._id == e._id} ? print("") : eventsToUpdate.append(e)) )
            }
        }
        
//        print("trying to update realm now...")
//        print("events tba: ")
//        print(eventsToAdd)
//
//        print ("events to update: ")
//        print(eventsToUpdate)
//
//        print("events to be deleted: ")
//        print(dbEventsToDelete)
        
        for e in dbEventsToDelete {
            dbiCalEvents.removeAll(where: {$0._id == e._id})
//            dbManualEvents.removeAll(where: {$0._id == e._id})
        }
        
        self.deleteFromRealm(eventsToDelete: dbEventsToDelete)
        dbEventsToDelete.removeAll()
//        print(dbiCalEvents)
        self.updateInRealm(eventsToUpdate: eventsToUpdate)
        
        self.events.append(contentsOf: eventsToAdd)
        self.sendToRealm()
        
        self.events.removeAll()
        
        self.events.append(contentsOf: iCalEvents)
        self.events.append(contentsOf: dbManualEvents)
        
//        print("made it to end of iCalSync, here are our events:", self.events)
        
    
        
//        self.events.append(contentsOf: eventsToUpdate)
//        self.events.append(contentsOf: dbManualEvents)
    }
    
    
    func loadFromiCal(registering: Bool) -> Void {
    //    let eventsVM = EventsViewModel()
        print("loadFromiCal Called")
        
        let eventStore = EKEventStore()
        
        var events = [Event]()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                
                let calendars = eventStore.calendars(for: .event)
                
                print("granted!")
                let weekFromNow = Date(timeIntervalSinceNow: 3600*24*7)
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: calendars.filter{$0.title == "Calendar"})
                
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
//                    print(e.eventIdentifier!)
                    // WORk HERE -- need to check to see if event is already in DB
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
                    newEvent.Tasks = RealmSwift.List<String>()
                    for _ in 0...randomNums.randomElement()! {
                        let newTask = Event()
                        newTask.UserId = userid
                        newTask.Category = taskCat
                        newTask.Title = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
                        newTask.Description = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
                        newTask.NotifBefore = -1
                        newTask.OnTime = -1
                     //   newEvent.Tasks?.append(newTask)
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
        print("loadfromDB called")
//        self.events = [Event]()
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
                    if !e.isInvalidated {
                        !self.events.contains(where: {$0._id == e._id}) ? self.events.append(e) : print("not appending to events")
                    }
//                    if e.CreationMethod == ManualCreation {
//                        events.append(e)
//                    } else if e.CreationMethod == iCalCreation {
//                        try! realm.write {
//                            realm.delete(e)
//                        }
//                    }
                }
                print("self.events after loadfromdb append:", self.events)
        
//                self.events.append(contentsOf: events)
            }
        }
    }
    
    
    
    func sendToRealm() -> Void {
        print("sendToRealm called")
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
    
    func updateInRealm(eventsToUpdate: [Event]) -> Void {
        print("updateInRealm called")
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
            try! realm.write {
                realm.add(eventsToUpdate, update: .modified)
            }
        }
    }
    
    func deleteFromRealm(eventsToDelete: [Event]) -> Void {
        print("deleteFromRealm called")
        if let app = app {
            let user = app.currentUser
            let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
//            for e in eventsToDelete {
//                try! realm.write {
////                    realm.delete(e.Category!)
//                    realm.delete(e)
//                }
//            }
            try! realm.write {
                realm.delete(eventsToDelete)
//                self.events.removeAll(where: self.events.contains(_:))
            }
            
        }
    }
}
