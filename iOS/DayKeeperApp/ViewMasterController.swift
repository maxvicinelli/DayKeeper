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
        if authModel.viewingSettings {
            SettingsView(authModel: authModel)
        } else if let _ = app!.currentUser {
            EventsView(authModel: authModel, app: app!, eventsVM: getEventsFromDb())
        } else if authModel.authenticated {
            if authModel.registering {
                EventsView(authModel: authModel, app: app!, eventsVM: loadFromiCal(eventStore: store, eventsVM: eventsVM))
            }
            else {
                EventsView(authModel: authModel, app: app!, eventsVM: getEventsFromDb())
            }
        }
        else {
            if authModel.registering {
                RegistrationView()
                    .environmentObject(authModel)
            }
            else {
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
