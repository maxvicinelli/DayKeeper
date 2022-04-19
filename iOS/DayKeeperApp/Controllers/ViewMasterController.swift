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
    @ObservedObject var eventsVM: EventsViewModel
    
    var body: some View {
//        if let _ = app!.currentUser {
//            EventsView(app: app!, eventsVM: getEventsFromDb())
//        }
        
        if authModel.viewingSettings {
            SettingsView(authModelParam: authModel)
        }
      
        else if authModel.authenticated {
//            if authModel.registering {
                 
            MainTabView(authModelParam: authModel, eventsVMParam: eventsVM)

//            }
//            else {
//                EventsView(authModel: authModel, app: app!, eventsVM: getEventsFromDb())
//                let y = print("signed in - getting from DB")
//            }
        }
        else {
            if authModel.registering {
                RegistrationView(authModel: authModel, eventsViewModel: eventsVM)
                    .environmentObject(authModel)
            }
            else {
                LoginView(eventsViewModel: eventsVM)
                    .environmentObject(authModel)
            }
        }
    }
}
struct ViewMasterController_Previews: PreviewProvider {
    static var previews: some View {
        ViewMasterController(authModel: AuthenticationModel(), eventsVM: EventsViewModel())
    }
}
