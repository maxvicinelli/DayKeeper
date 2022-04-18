//
//  ActionNotifManager.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/27/22.
//

import Foundation
import UserNotifications
import RealmSwift

final class ActionNotifManager: NSObject, UNUserNotificationCenterDelegate {
    
    var didntRespond = false
    var didntRespond_title_name = ""
    var didntRespondDate = Date()
    
    
    // year: Int, month: Int,
    func scheduleNotification(title: String, year: Int, month: Int,day: Int, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
        
        print("scheduling action notification w/ title \(title)")
        
        let earlyAction = UNNotificationAction(identifier: "early", title: "I was early", options: [])
        let lateAction = UNNotificationAction(identifier: "late", title: "I was late", options: [])
    
    
        // Add actions to a category
        let category = UNNotificationCategory(identifier: "statusCategory", actions: [earlyAction, lateAction], intentIdentifiers: [], options: [])
    
        // Add the category to Notification Framwork
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
    
    
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.year = year
        dateComponents.month = month //assuming weekly repeats
        dateComponents.day = day
//        print(dateComponents)
        // Question -- do we want repeats: true below? I feel like we just want each day's notifications to be created specifically for that day?
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Were you on time to your event?"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "statusCategory"
        content.userInfo = ["date" : NSCalendar.current.date(from: dateComponents)!]
        let unique_identifier = title + "statusNotification"
    
        let request = UNNotificationRequest(identifier: unique_identifier, content: content, trigger: trigger)
        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    
    }
    
    func scheduleAlarmNotification(onTime: Int, title: String, year: Int, month: Int, day: Int, hour: Int, minute: Int, completion: @escaping (Error?) -> Void){
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
        content.body = "Let's get you on time to your event!"
        content.sound = UNNotificationSound.default
//                let unique_identifier = title + "statusNotification"
    
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
 //        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
//        }

   
   }
    
    func updateOtherEvents(event: Event, early: Bool) {
        print("updateOtherEvents called")
        
        for otherEvent in getEventsFromDb() {

            if let app = app {
                let user = app.currentUser
                let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
                try! realm.write {
//
//            let otherEvent2 = otherEvent
           
                    if otherEvent.Category?.Title == event.Category?.Title {
             
                        if early {
//                    event.Timeliness.append(0) //append a 0 to list
//                    event.Timeliness.remove(at: 0) //pop first element to keep moving 5 day window
                    
                    //event.OnTime = max(onTimeVal - 1,0)
                    
//                    let lastTwoDays = event.Timeliness.suffix(from: 2)
//                    
//                    //if the user has been ontime 2 times in the last 2 days, decrement the notification schedule
//                    if lastTwoDays.reduce(0, +) == 0 {
//                        event.OnTime = max(event.OnTime-1, 0)
//                    }
                            otherEvent.OnTime = max(otherEvent.OnTime-1, 0)

               
                        }
              
                        else {
//                    event.Timeliness.append(1) //append a 1 to list
//                    event.Timeliness.remove(at: 0) //pop first element to keep moving 5 day window
//
                    //if the user has been late 3 times in the last 5 days, decrement the notification schedule
                            //                            print("Before making change to onTime, category:", otherEvent.Category?.Title, "event title:", otherEvent.Title, "onTime count:", otherEvent.OnTime)
                            otherEvent.OnTime = min(otherEvent.OnTime+1, 5)
                            //                            print("After making change to onTime, category:", otherEvent.Category?.Title, "event title:", otherEvent.Title, "onTime count:", otherEvent.OnTime)

//                    if ( event.Timeliness.reduce(0, +) >= 3) {
//                        event.OnTime = min(event.OnTime+1, 5)
//                    }
                        }
                    }
                }
            }
        }
        createStatusUpdateNotifs()
    }
    
   
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           
            print("in userNotificationCenter")
           
            let event_title = response.notification.request.content.title
            print("userNotificationCenter callback called, event_title:", event_title)
               
            if let event = getEventsFromDb().first(where: {$0.Title == event_title}) {
                print("event was found in db")
                switch response.actionIdentifier{
                case "early":
                    print("early")
                    updateOtherEvents(event: event, early: true)
                case "late":
                    print("late")
                    updateOtherEvents(event: event, early: false)
                case UNNotificationDefaultActionIdentifier:
                    print("notification was clicked on and app opened, but no response was recorded")
                    print("Event title:", event.Title)
                    didntRespond_title_name = event.Title
                    didntRespondDate = event.StartDate
                    didntRespond = true
                case UNNotificationDismissActionIdentifier:
                    print("notification was dismissed")
                    didntRespond_title_name = event.Title
                    didntRespondDate = event.StartDate
                    didntRespond = true
                default:
                    print("default case")
                }
            }
            else {
                print("item could not be found")
            }
            completionHandler()
    }
    
    
    func createStatusUpdateNotifs() {
        print("createStatusUpdateNotifs() called")

        print("printing current pending notifications before deleting and remaking:")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request.content.title)
            }
        })

        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        
        print("printing current pending notifications after deleting:")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request.content.title)
            }
        })
        print("Now creating notifications")
        for event in getEventsFromDb(){
            print(event.Title)
            let calendarDate = Calendar.current.dateComponents([.minute, .hour, .day, .year, .month], from: event.StartDate)
            //year: calendarDate.year!, month: calendarDate.month!,

            scheduleAlarmNotification(onTime: event.OnTime , title: event.Title, year: calendarDate.year!, month: calendarDate.month!, day: calendarDate.day!, hour: calendarDate.hour!, minute: calendarDate.minute!){ error in
                
                if error == nil {
                    DispatchQueue.main.async {
                        print("scheduled alarm notification for event: \(event.Title)")
                    }
                } else {
                    print("there was an error w/ scheduling alarm notification")
                    print(error)
                }
            }
            scheduleNotification(title: event.Title, year: calendarDate.year!, month: calendarDate.month!, day: calendarDate.day!, hour: calendarDate.hour!, minute: calendarDate.minute!) { error in
                if error == nil {
                    DispatchQueue.main.async {
                        print("scheduled action notification for event: \(event.Title)")
                    }
                } else {
                    print("there was an error w/ scheduling action notif")
                    print(error)
                }
            }
        }
        print("printing current pending notifications after deleting and remaking:")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            print("printing notification requests: ")
            for request in requests {
                
                print(request.content.title)
//                print(request.content.userInfo)
                
            }
        })
        print("finished executing createStatusUpdateNotifs")
    }
}

