//
//  ViewMasterController.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/2/22.
//

import SwiftUI
import EventKit
import RealmSwift

struct ViewMasterController: View {
    
    @ObservedObject var authModel: AuthenticationModel
    @ObservedObject var eventsVM: EventsViewModel = EventsViewModel()
    var store = EKEventStore()
    
    var body: some View {
        if let _ = app!.currentUser {
            EventsView(app: app!, eventsVM: getEventsFromDb())
        } else {
            if authModel.authenticated {
                if authModel.registering {
                    EventsView(app: app!, eventsVM: loadFromiCal(eventStore: store, eventsVM: eventsVM))
                } else {
                    EventsView(app: app!, eventsVM: getEventsFromDb())
                }
            } else {
                LoginView()
                    .environmentObject(authModel)
            }
            
        }
    }
}

struct ViewMasterController_Previews: PreviewProvider {
    static var previews: some View {
        ViewMasterController(authModel: AuthenticationModel())
    }
}
