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
    @ObservedObject var settingsVM: SettingsViewModel
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
    
    
//    var filteredEvents: [Event] {
//        eventsVM.events.filter { event in
//            (!event.isInvalidated && event.StartDate > Date.now &&  (Calendar.current.isDateInToday(event.StartDate) || !showTodayEventsOnly))
//        }
//    }
    
    init(authModelParam: AuthenticationModel, appParam: RealmSwift.App, eventsVMParams: EventsViewModel, settingsVMParam: SettingsViewModel) {
            UITableView.appearance().backgroundColor = UIColor(Color(red:0.436, green: 0.558, blue: 0.925)) // Uses UIColor
            self.authModel = authModelParam
            self.app = appParam
            self.eventsVM = eventsVMParams
            self.settingsVM = settingsVMParam
        }
    
    func setIsCreatePresentedTrue() -> Void {
        self.isCreatePresented = true
    }
    

    var body: some View {
        NavigationView {
        VStack {
            HStack(spacing: 10){
                            Text("Welcome")
                                .frame(width: 150, alignment: .leading) // setting width and line limit can force wrapping
                                .lineLimit(2)
                                .shadow(radius: 15)
                                .foregroundColor(Color.textColor)
                                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size:35)!))
                                .padding(.leading, 60)
                                .background(RoundedRectangle(cornerRadius: 60).fill(Color(red:0.436, green: 0.558, blue: 0.925 )))
                                .minimumScaleFactor(0.5)
                                            .lineLimit(1)

                Button("Sync iCal", action: {
                    print("before ical sync, these are our events:", eventsVM.events)
                    eventsVM.events.removeAll()
                    eventsVM.iCalSync()
                    print("ical sync done, here are the events we now have: ", eventsVM.events)
//                    DispatchQueue.main.async {
//                    eventsVM.loadFromDB()
                        
//                    }
//                    eventsVM.loadFromDB()
//                    eventsVM.reload()
//                    eventsVM.loadFromDB()
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
            .frame(height: 80, alignment: .center)
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
            .offset(x: -30, y: 0)

            VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        VStack {
                        Text("Today's Events Only")
                            .foregroundColor(Color.textColor)
                            .font(.system(size: 26))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Toggle("Events", isOn: $showTodayEventsOnly)
                            .labelsHidden()
                        }
                        .padding()
                        
                        
                        List(eventsVM.events) { event in
                           if !event.isInvalidated {
                            NavigationLink (
                                destination: EventRow(event: event, actionNotificationManager: actionNotifManager),
                                label: {
                                
                                    Text(event.Title) + Text("\n") +
                                    Text(date2text(event: event)).foregroundColor(Color(red:0.436, green: 0.558, blue: 0.925)).font(.system(size: 22))
                                        // .onAppear(perform: {eventsVM.update()})
                                })
                                .listRowBackground(Color(red:1.0, green: 0.941, blue: 0.612))
                            }
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
                        .onAppear(perform: {
                            print("onAppear called in EventsView")
                            actionNotifManager.createStatusUpdateNotifs()})
                    
                        .onChange(of: scenePhase) { newPhase in
                            if newPhase == .active {
                                reloadDidntRespond()
                            }
                        }
                        .onAppear(perform: {reloadDidntRespond()})
                        .background(Color(red:0.436, green: 0.558, blue: 0.925))
                        .sheet(isPresented: $isCreatePresented, onDismiss: actionNotifManager.createStatusUpdateNotifs){
//                            NavigationView {
                                CreateEventView(isPresented: $isCreatePresented, eventsVM: eventsVM)
//                            }
                            .accentColor(.primary)
                        }
                        .sheet(isPresented: $isNotifResponsePresented){
//                            NavigationView {
                                NotifResponseView(isPresented: $isNotifResponsePresented,
                                                  notificationTitle: actionNotifManager.didntRespond_title_name,
                                                  eventStartDate: didntRespondEventDate,
                                                  actionNotifManger: actionNotifManager)
//                            }
                        }
                }
            }
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
        }
//        .frame(height: 900)
//        .offset(x: 0, y: -160)
        .background(Color(red:0.436, green: 0.558, blue: 0.925))

    }
}



struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventsView(authModelParam: AuthenticationModel(), appParam: app!, eventsVMParams: dummyEvents(), settingsVMParam: SettingsViewModel())//, events: dummyEvents())//loadFromiCal(eventStore: EKEventStore()))
                .previewInterfaceOrientation(.portraitUpsideDown)
            EventsView(authModelParam: AuthenticationModel(), appParam: app!, eventsVMParams: dummyEvents(), settingsVMParam: SettingsViewModel())//, events: dummyEvents())//loadFromiCal(eventStore: EKEventStore()))
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}

func date2text(event: Event) -> String {
    // Create Date Formatter
    let dateFormatter = DateFormatter()

    // Set Date Format
    dateFormatter.dateFormat = "E, HH:mm"

    let text = dateFormatter.string(from: event.StartDate) + "-" + dateFormatter.string(from: event.EndDate)
    return text
}
