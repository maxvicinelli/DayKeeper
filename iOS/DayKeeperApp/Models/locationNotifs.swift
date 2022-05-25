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
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
    //sort events by oldest to newest date
    let sorted_events =  sort_events_by_date()
    print(sorted_events)
    
    // underlying logic: if list is sorted by ascending date, oldest to newest,
    // the first positive time interval is the nearest date in the future
    let soonest_event = find_soonest_event(events: sorted_events)
    
    //create notification for nearest event
    // " Your next event is at X:XX, you should leave your current location by Y:YYY
    // function will calculate the next time to check user's location
    create_location_notif(event: soonest_event)
    
    // function will ccheck at the start time if user was early or late
    // function can then call initialize_location_notif_cycle(), to then start the cycle
    check_status()
    
}

func create_location_notif(event: Event){
    // check distance from current position and event, and the time it will take to leave
    var driving_time = 0.0
    getDrivingTime(event: event){ time in
       driving_time = time!}
    
    
    let diffComponents = Calendar.current.dateComponents([.second, .minute], from: Date(), to: event.StartDate)
    let time_to_event = diffComponents.second
   // let minutes = diffComponents.minute
    let departure_time  = Calendar.current.date(
        byAdding: .second,
        value: -1 * time_to_event!,
        to: event.StartDate)
    // create timer to check location in (current time - event time)/2 minutes
    
    // Current time 10 am: x
    // Departure time 11:  y
    // Event time 12 pm:   z
    // Driving time = (z-y)
    // We want to check in (y-x)/2 time
    // (Y-x) = (z-x) - (Z-y)
    let timer = Timer.scheduledTimer(withTimeInterval: (driving_time-Double(time_to_event!))/2.0, repeats: false) { timer in
        print("Timer fired!")
        
        var new_driving_time = 0.0
        getDrivingTime(event: event){ time in
            new_driving_time = time!}
        let new_departure_time  = Calendar.current.date(
            byAdding: .second,
            value: -1 * Int(new_driving_time),
            to: event.StartDate)
        
        //user is still on time
        if (Date() < new_departure_time!) {
            NSLog("current time is earlier than new departure time");
            
            //user is running early and departure time has moved later
            if (departure_time! > new_departure_time!) {
                NSLog("previous departure time is later than new departure time");
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, h:mm a" // Sep 12, 2:11 PM --> MMM d, h:mm a
                let stringDate: String = dateFormatter.string(from: new_departure_time! as Date)
                let calendarDate = Calendar.current.dateComponents([.minute, .hour, .day, .year, .month], from: event.StartDate)
                scheduleLocationNotification(onTime: event.OnTime , title: event.Title, year: calendarDate.year!, month: calendarDate.month!, day: calendarDate.day!, hour: calendarDate.hour!, minute: calendarDate.minute!, customMessage: "Your new departure time for \(event.Title) is \(stringDate)" ){ error in
                    if error == nil {
                        DispatchQueue.main.async {
                            print("scheduled alarm notification for event: \(event.Title)")
                        }
                    } else {
                        print("there was an error w/ scheduling alarm notification")
                        print(error)
                    }
                }
                
                
            }
            //user is running early but departure time has moved earlier
            else{
                
                //do nothing
                
            }
            
        }
        //user is late or just on time
        else {
            let calendarDate = Calendar.current.dateComponents([.minute, .hour, .day, .year, .month], from: event.StartDate)
            scheduleLocationNotification(onTime: event.OnTime , title: event.Title, year: calendarDate.year!, month: calendarDate.month!, day: calendarDate.day!, hour: calendarDate.hour!, minute: calendarDate.minute!, customMessage: "You should leave now for  new \(event.Title)!" ){ error in
                if error == nil {
                    DispatchQueue.main.async {
                        print("scheduled alarm notification for event: \(event.Title)")
                    }
                } else {
                    print("there was an error w/ scheduling alarm notification")
                    print(error)
                }
            }
            
        }
        
        
        
        // then create new timer with same rules, "recursively"
        if (event.StartDate < new_departure_time!) {
           //  timer.invalidate() // do we need this?
            NSLog("current time is earlier than new departure time");
            create_location_notif(event: event)
        
    }
        //else, end calls to create_location_notif() and go back to initialize_location_notif_cycle() to call check_status()

        
        
}
}
func check_status(){
    // at event time, check location of user
    // update notification severity based on whether user is late or not
    
    
    //if early
    
    
    //if late
    
    
    
    //restart cycle
    //initialize_location_notif_cycle()
}

func sort_events_by_date() -> [Event] {
    let events = getEventsFromDb()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM, yyyy"// yyyy-MM-dd"
    
    for event in events {
        let date = dateFormatter.date(from: dateFormatter.string(from: event.StartDate))
        if let date = date {
            event.StartDate = date
        }
    }
    
    return  events.sorted(by: { $0.StartDate < $1.StartDate }) //ascending order
}

func find_soonest_event(events: [Event]) -> Event {
    var soonest_event = events.first!
    for event in events{
        let timeInterval = event.StartDate.timeIntervalSince(NSDate() as Date)
//find time interval from now till event
        
        if timeInterval > 0 {
            soonest_event = event
            break
        }
    }
    
    return soonest_event
}

    func scheduleLocationNotification(onTime: Int, title: String, year: Int, month: Int, day: Int, hour: Int, minute: Int, customMessage: String, completion: @escaping (Error?) -> Void){
        //scheduled alarm will sound at a time based on notification severity
        //        for event in getEventsFromDb(){
        //            if event.Category?.Title == category{
        //
        //            }
        //        }
        //        if let event = getEventsFromDb().first(where: {$0.Category?.Title == category}) {
        //           severity = event.OnTime * 5
        //       }
        
        //        if event.Category?.Title == category {
        //                severity = event.OnTime * 5
        //print("in scheduleAlarmNotification, event.Title and event.onTime:", title, onTime)
        
        
        print("scheduling alarm notification w/ title \(title)")
        
        
        let severity = onTime + 2
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.year = year
        dateComponents.month = month // assuming weekly repeats
        dateComponents.day = day
        //        print(dateComponents)
        // Question -- do we want repeats: true below? I feel like we just want each day's notifications to be created specifically for that day?
        
        let date = NSCalendar.current.date(from: dateComponents)! //convert components to date so we can modify
        let modifiedDate = Calendar.current.date(byAdding: .minute, value: -severity, to: date)! //modify date
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: modifiedDate) //convert back to component
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = title + " Alarm"
        content.body = customMessage
        content.sound = UNNotificationSound.default
        //                let unique_identifier = title + "statusNotification"
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        


    }


