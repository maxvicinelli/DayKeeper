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
    @State private var isCreatePresented = false
    
    
    func createTodaysNotifs() {
        print("running createTodaysNotifs() method")
        for event in eventsVM.events {
            if Calendar.current.isDateInToday(event.StartDate){
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.StartDate)
                guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day, let hour = dateComponents.hour, let minute = dateComponents.minute
                    else { return }
                notificationManager.createLocalNotifications(
                    title: event.Title,
                    year: year,
                    month: month,
                    day: day,
                    hour: hour,
                    minute: minute) { error in
                        if error == nil {
                            DispatchQueue.main.async {
                                print("notifications for today were successfully created!")
                            }
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    var infoOverlayView: some View {
        switch notificationManager.authorizationStatus {
        case .denied:
            InfoOverlayView(
                infoMessage: "Please Enable Notification Permission In Settings",
                buttonTitle: "Settings",
                systemImageName: "gear",
                action: {
                    if let url = URL(string: UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            )
        default:
            if notificationManager.notifications.count == 0 {
                    InfoOverlayView(
                        infoMessage: "Press here to create today's notifications!",
                        buttonTitle: "Important! Press below!",
                        systemImageName: "exclamationmark.bubble",
                        action: {
                            createTodaysNotifs()
                        }
                    )
            }
            else{
                EmptyView()
            }
        }
    }
    
    
    var filteredEvents: [Event] {
        eventsVM.events.filter { event in
            (Calendar.current.isDateInToday(event.StartDate) || !showTodayEventsOnly )
            
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
            .overlay(infoOverlayView)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){ _ in
                notificationManager.reloadAuthorizationStatus()
            }
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
            .navigationBarItems(trailing: Button {
                isCreatePresented = true
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            })
            .sheet(isPresented: $isCreatePresented){
                NavigationView {
                    CreateEventView(isPresented: $isCreatePresented,
                    notificationManager: notificationManager)
                }
                .accentColor(.primary)
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

