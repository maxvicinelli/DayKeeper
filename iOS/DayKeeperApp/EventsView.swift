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
import UIKit



struct EventsView: View {
    @ObservedObject var authModel: AuthenticationModel
    @ObservedObject var app: RealmSwift.App
    //var events: [Event]
    @ObservedObject var eventsVM : EventsViewModel
    var eventStore = EKEventStore()
    @StateObject var notificationManager = NotificationManager()
    @State private var showTodayEventsOnly = false
    @State private var isCreatePresented = false
    @State private var isNotifResponsePresented = false
    @State private var didntRespondEventTitle = ""
    @State private var didntRespondEventDate = Date()
    var actionNotifManager = ActionNotifManager()
    @Environment(\.scenePhase) var scenePhase
    
    
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
            EmptyView()
        }
        
    }
    
    func reloadDidntRespond() {
        isNotifResponsePresented = actionNotifManager.didntRespond
        didntRespondEventTitle = actionNotifManager.didntRespond_title_name
        didntRespondEventDate = actionNotifManager.didntRespondDate
    }
    
    
    var filteredEvents: [Event] {
        eventsVM.events.filter { event in
            (Calendar.current.isDateInToday(event.StartDate) || !showTodayEventsOnly)
        }
    }

    var body: some View {
        
        ZStack { //Makes background a specific color
            Color(red:0.436, green: 0.558, blue: 0.925 )
                .edgesIgnoringSafeArea(.all)
        
            VStack {
                
                HStack {
                    
                    Text("Welcome, User")
                        .frame(width: 200) // setting width and line limit can force wrapping
                        .lineLimit(2)
                        .shadow(radius: 15)
                        .foregroundColor(Color.textColor)
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 60)!))
                        .padding(.vertical, 5.0)
                        .background(RoundedRectangle(cornerRadius: 60).fill(Color(red:0.436, green: 0.558, blue: 0.925 )))
                        .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                    
                    Button("?") {
                        print("will be help screen button")
                
                    }
                    .font(Font(uiFont: UIFont(name: "Karla-Regular", size: 30)!))
                    .frame(width: 60, height: 60)
                    .background(RoundedRectangle(cornerRadius: 60).fill(Color(red:0.996, green: 0.396, blue: 0.31 )))
                    .foregroundColor(Color.black)
                }
                
                Text("Here's Your Schedule for the Day")
                    .font(Font(uiFont: UIFont(name: "Karla-Regular", size: 24)!))
                    .foregroundColor(Color(red: 0.02, green: 0.016, blue: 0.004))
                    .background(Color(red:0.436, green: 0.558, blue: 0.925 ))
                
                
                Toggle(isOn: $showTodayEventsOnly){
                    Text("Here's Your Schedule for the Day")
                }
                List {
                    ForEach(filteredEvents) { event in
                        NavigationLink (
                            destination: EventRow(event: event),
                            label: {
                                Text(event.Title)
                                    .listRowBackground(RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.orange)
                                    )
                                    // .onAppear(perform: {eventsVM.update()})
                            })
                        }
                    }
                .listStyle(.automatic)
                .foregroundColor(Color(red: 0.504, green: 0.504, blue: 0.054))
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
                .onAppear(perform: {actionNotifManager.createStatusUpdateNotifs()})
            
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        print("now active")
                        reloadDidntRespond()
                    }
                    
                }
            
                // .onAppear(perform: {reloadDidntRespond()})
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
                .sheet(isPresented: $isNotifResponsePresented){
                    NavigationView {
                        NotifResponseView(isPresented: $isNotifResponsePresented,
                                          notificationTitle: didntRespondEventTitle,
                                          eventStartDate: didntRespondEventDate)
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

