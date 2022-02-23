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
    
    
    func loadEvents(registering: Bool) -> Void {
//        if registering {
//            self.events = loadFromiCal()
//        } else {
            self.events = getEventsFromDb()
        //}
    }
    
    
    func loadFromiCal() -> Void {
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
//                    print("got a new guy in events!")
//                    print(events)
                }
                 
                DispatchQueue.main.async {
                    self.events = events
                    print("yooooo we finished")
                    print(self.events)
                }
                
            }
        }
    }
    
    
    
    func updateEvents() -> Void {

        print("----------------------------")

        self.events = getEventsFromDb()
    }
//    override func viewWillAppear(_ animated : Bool) {
//        events = getEventsFromDb().events
//        super.viewWillAppear(animated)
//        print("test")
//    }
}
