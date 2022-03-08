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
        print("reload didnt respond called")
        isNotifResponsePresented = actionNotifManager.didntRespond
        didntRespondEventTitle = actionNotifManager.didntRespond_title_name
        didntRespondEventDate = actionNotifManager.didntRespondDate
        print("isNotifResponsePresented:", isNotifResponsePresented, "didntRespondEventTitle:", didntRespondEventTitle, "didntRespondEventDate:", didntRespondEventDate)
    }
    
    
    var filteredEvents: [Event] {
        eventsVM.events.filter { event in
            (Calendar.current.isDateInToday(event.StartDate) || !showTodayEventsOnly)
        }
    }
    
    init(authModelParam: AuthenticationModel, appParam: RealmSwift.App, eventsVMParams: EventsViewModel) {
            UITableView.appearance().backgroundColor = UIColor(Color(red:0.436, green: 0.558, blue: 0.925)) // Uses UIColor
            self.authModel = authModelParam
            self.app = appParam
            self.eventsVM = eventsVMParams
        }
    
    func setIsCreatePresentedTrue() -> Void {
        self.isCreatePresented = true
    }
    

    var body: some View {
        
        VStack {
            HStack {
                Text("Welcome")
                    .frame(width: 200, alignment: .leading) // setting width and line limit can force wrapping
                    .lineLimit(2)
                    .shadow(radius: 15)
                    .foregroundColor(Color.textColor)
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 45)!))
                    .padding(.vertical, 5.0)
                    .background(RoundedRectangle(cornerRadius: 60).fill(Color(red:0.436, green: 0.558, blue: 0.925 )))
                    .minimumScaleFactor(0.5)
                                .lineLimit(1)

                Button("Settings", action: {
                    authModel.updateSettings()
                    print("updated settings!")
                })
                .font(Font(uiFont: UIFont(name: "Karla-Regular", size: 14)!))
                .frame(width: 80, height: 40, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 60).fill(Color(red:0.996, green: 0.396, blue: 0.31 )))
                .foregroundColor(Color.black)
                
                
                Button("Create Event", action: {
                    setIsCreatePresentedTrue()
                })
                .font(Font(uiFont: UIFont(name: "Karla-Regular", size: 14)!))
                .frame(width: 80, height: 40, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 60).fill(Color(red:0.996, green: 0.396, blue: 0.31 )))
                .foregroundColor(Color.black)
            }
            .padding(.top, 10)
            .frame(width: 500, height: 80, alignment: .center)
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
        
            VStack(spacing: 0) {
                
                NavigationView {
                    VStack(spacing: 0) {
                        Toggle(isOn: $showTodayEventsOnly){
                            Text("Today's Events Only")
                                .foregroundColor(Color.textColor)
                        }
                        .padding()
                        List(filteredEvents) { event in
                            NavigationLink (
                                destination: EventRow(event: event),
                                label: {
                                    Text(event.Title)
                                        // .onAppear(perform: {eventsVM.update()})
                                })
                                .listRowBackground(Color(red:1.0, green: 0.941, blue: 0.612))
                            }
                        }
                        .overlay(infoOverlayView)
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){ _ in
                            notificationManager.reloadAuthorizationStatus()
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
                        .onAppear(perform: {reloadDidntRespond()})
                        .background(Color(red:0.436, green: 0.558, blue: 0.925))
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
                                                  notificationTitle: actionNotifManager.didntRespond_title_name,
                                                  eventStartDate: didntRespondEventDate,
                                                  actionNotifManger: actionNotifManager)
                            }
                        }
                }
            }
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
            .padding(.top, -8)
        }
    }
}



struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(authModelParam: AuthenticationModel(), appParam: app!, eventsVMParams: dummyEvents())//, events: dummyEvents())//loadFromiCal(eventStore: EKEventStore()))
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

