//
//  EventView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/4/22.
//
//  Edited by Jonah Kershen on 2/13/22 to incorporate NotificationMAnager

import SwiftUI
import RealmSwift

struct EventView: View {
//    @ObservedRealmObject var events: [Event]
    @StateObject private var notificationManager = NotificationManager()
    
    var events: [Event]
    //@ObservedRealmObject var event: Event
    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                     NavigationLink {
                        EventRow(event: event)
                    } label:
                    {
                        Text(event.Title)
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                Button("Send to Realm", action: { sendToRealm(events: events) })
            }
            .onAppear(perform: notificationManager.reloadAuthorizationStatus)
            .onChange(of: notificationManager.authorizationStatus) { authorizationStatus in
                switch authorizationStatus {
                case .notDetermined:
                    notificationManager.requestAuthorization()
                    break
                case .authorized:
                    //get local notifications
                    notificationManager.reloadLocalNotifications()
                    break
                default:
                    break
                }
            }
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(events: dummyEvents())
.previewInterfaceOrientation(.portraitUpsideDown)
        //EventView()
    }
}
