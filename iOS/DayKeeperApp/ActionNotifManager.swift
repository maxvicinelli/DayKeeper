//
//  ActionNotifManager.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/27/22.
//

import Foundation
import UserNotifications

final class ActionNotifManager: NSObject, UNUserNotificationCenterDelegate {
    
    // year: Int, month: Int,
    func scheduleNotification(title: String, day: Int, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
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
        //dateComponents.year = year
        //dateComponents.month = month assuming weekly repeats
        dateComponents.day = day
//        print(dateComponents)
        // Question -- do we want repeats: true below? I feel like we just want each day's notifications to be created specifically for that day?
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
        let content = UNMutableNotificationContent()
        content.title = title + "Status Update"
        content.body = "Where you on time to your event?"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "statusCategory"
        let unique_identifier = title + "statusNotification"
    
        let request = UNNotificationRequest(identifier: unique_identifier, content: content, trigger: trigger)
        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    
    }
    

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        if response.actionIdentifier == "early" {
            print("early")
            // not sure what the exact syntax is
            // event.OnTime = max(event.OnTime - 1,0)
            
            // # if the user has been ontime 2 times in the last 2 days, decrement the notification schedule
            // elif events[row[1]][-2:] == [0] * early_threshold:
            //schedule_list[row[1]] += [max(0, schedule_list[row[1]][-1] - 1)]
            // else:
            //  schedule_list[row[1]] += [schedule_list[row[1]][-1]]
        
            
        }
        else{ // Vegetable
            print("late")
            // event.OnTime = max(event.OnTime + 1,5)
            
            // if the user has been late 3 times in the last "window" days, increment the notification schedule
            //if sum(events[row[1]][-window:]) >= late_threshold:
            //schedule_list[row[1]] += [min(4, 1+ schedule_list[row[1]][-1])]
            
        
        
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
        //delete all the messages cause we'll be remaking them, (avoiding duplicates)
//        for event in getEventsFromDb(){
//            let unique_identifier = event.Title + "statusNotification"
//            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [unique_identifier])
//        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        
        print("printing current pending notifications after deleting:")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request.content.title)
            }
        })
        print("Printing events currently in DB")
        for event in getEventsFromDb(){
            print(event.Title)
            let calendarDate = Calendar.current.dateComponents([.minute, .hour, .day, .year, .month], from: event.StartDate)
            //year: calendarDate.year!, month: calendarDate.month!,

            scheduleNotification(title: event.Title, day: calendarDate.day!, hour: calendarDate.hour!, minute: calendarDate.minute!) { error in
                if error == nil {
                    DispatchQueue.main.async {
                        // self.isPresented = false
                    }
                }
            }
        }
        print("printing current pending notifications after deleting and remaking:")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request.content.title)
            }
        })
    }
}
