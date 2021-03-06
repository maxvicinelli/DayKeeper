//
//  NotificationManager.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/13/22.
//
// Tutorial: https://www.youtube.com/watch?v=iRjyk1S0nvo&t=1s

import Foundation
import UserNotifications

final class NotificationManager: ObservableObject{
    @Published private var isNotifResponsePresented = false
    // @Published private var actionNotifManager = ActionNotifManager(self)
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    @Published private(set) var notifications: [UNNotificationRequest] = []

    
    func reloadNotifResponseVar() {
         
    }
    
    func setNotifResponsePresented(value: Bool) {
        self.isNotifResponsePresented = value 
    }
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
        DispatchQueue.main.async {
            self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }
    
    func reloadLocalNotifications() {
        print("reload local notifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
    
        }
    }
    
    func createLocalNotifications(title: String, year: Int, month: Int, day: Int, hour: Int, minute: Int, completion: @escaping (Error?) -> Void) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        print("now in createLocalNotifications")
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.sound = .default
    
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
        
        
        print("finished creating a notif for this event")
    }
    
    // method that creates notifications intelligently based on how late you have been recently
    func createIntelligentNotifs(startDate: Date, lateCounter: Int) {
        
    }
    
}
