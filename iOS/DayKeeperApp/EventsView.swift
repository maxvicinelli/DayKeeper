//
//  EventView.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/4/22.
//
//  Modified by Jonah Kershen to include NotificationManager

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
    @State private var showTodayEventsOnly = false
    
    
    var filteredEvents: [Event] {
        eventsVM.events.filter { event in
            (Calendar.current.isDateInToday(event.StartDate))
        }
    }

    var body: some View {

            
        NavigationView {
            List {
                Toggle(isOn: $showTodayEventsOnly){
                    Text("Today's Events")
                }
                ForEach(filteredEvents) { event in
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



struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(authModel: AuthenticationModel(), app: app!, eventsVM: dummyEvents())//, events: dummyEvents())//loadFromiCal(eventStore: EKEventStore()))
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

