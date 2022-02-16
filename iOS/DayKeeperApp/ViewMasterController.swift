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
        }
      
        if authModel.authenticated {
<<<<<<< HEAD
            
            if authModel.registering {
                EventsView(authModel: authModel, app: app!, events: dummyEvents())
            } else {
                EventsView(authModel: authModel, app: app!, events: dummyEvents())
            }
        }
        else {
            if authModel.registering {
                RegistrationView()
                    .environmentObject(authModel)
            } else {
                LoginView()
                    .environmentObject(authModel)
            }
=======
            EventsView(app: app!, eventsVM: getEventsFromDb())//loadFromiCal(eventStore: store, eventsVM: eventsVM))
        } else {
            LoginView()
                .environmentObject(authModel)
>>>>>>> d067a45 (getting events from db working, still working on ical integration)
        }
    }
}

struct ViewMasterController_Previews: PreviewProvider {
    static var previews: some View {
        ViewMasterController(authModel: AuthenticationModel())
    }
}
