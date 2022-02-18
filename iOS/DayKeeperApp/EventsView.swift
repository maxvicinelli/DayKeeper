//
//  EventView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/4/22.
//

import SwiftUI
import RealmSwift
import EventKit



struct EventsView: View {
    @ObservedObject var authModel: AuthenticationModel
    @ObservedObject var app: RealmSwift.App
    //var events: [Event]
    @ObservedObject var eventsVM : EventsViewModel
    var eventStore = EKEventStore()
    @StateObject private var notificationManager = NotificationManager()

    var body: some View {

            
        NavigationView {
            List {
                ForEach(eventsVM.events) { event in
                    NavigationLink {
                        EventRow(event: event)
                    } label:
                    {
                        Text(event.Title)
                            .onAppear(perform: {eventsVM.update()})
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                HStack {
                    Button("Settings", action: {
                        authModel.updateSettings()
                        print("updated settings!")
                    })
                    Button("Send to Realm", action: { sendToRealm(events: eventsVM.events) })
                }
            }
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



struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(authModel: AuthenticationModel(), app: app!, eventsVM: dummyEvents())//, events: dummyEvents())//loadFromiCal(eventStore: EKEventStore()))
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

