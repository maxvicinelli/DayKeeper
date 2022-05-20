//
//  locationNotifs.swift
//  DayKeeperApp
//
//  Created by Ariel Attias on 5/19/22.
//

import Foundation
import UserNotifications
import RealmSwift


// initialize notifs
func initialize_location_notif_cycle(){
    // delete all our notifications first
    
    //sort events by oldest to newest date
    
    let sorted_events =  sort_events_by_date()
    print(sorted_events)
    
    
    // underlying logic: if list is sorted by ascending date, oldest to newest,
    // the first positive time interval is the nearest date in the future
    
   let soonest_event = find_soonest_event(sorted_events)

    //create notification for nearest event
    // " Your next event is at X:XX, you should leave your current location by Y:YYY
    // function will calculate the next time to check user's location
    create_location_notif(soonest_event)
    
    
    // function will ccheck at the start time if user was early or late
    // function can then call initialize_location_notif_cycle(), to then start the cycle
    check_status()
    
}


func create_location_notif(Event event){
    // check distance from current position and event, and the time it will take to leave
    
    // create timer to check location in (current time - event time)/2 minutes
    
    
    // on timer conclusion, if user is on time don't do anything ,
    
    // if user is late/ time to leave is earlier than before, update them
    // then create new timer with same rules, "recursively"
    
}



func check_status(){
    // at event time, check location of user
    // update notification severity based on whether user is late or not
    
    //restart cycle
}


func sort_events_by_date() -> [Event] {
    let events = getEventsFromDb()
    
    
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM, yyyy"// yyyy-MM-dd"
    
    for event in events {
        let date = dateFormatter.date(from: event.StartDate)
        if let date = date {
            event.StartDate = date
        }
    }
    
    
    
    return  event.sorted(by: { $0.StartDate < $1.StartDate }) //ascending order
}


func find_soonest_event([Event] events) -> Event {
    let soonest_event = events.first
    for event in events{
        var timeInterval = events.StartDate.timeIntervalSinceDate(NSDate()) //find time interval from now till event
        
        if timeInterval > 0 {
            let soonest_event = event
            break
        }
    }
    
    
    return soonest_event
}
