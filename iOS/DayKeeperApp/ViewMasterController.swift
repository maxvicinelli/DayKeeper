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
            SettingsView(authModel: authModel)
        }
      
        else if authModel.authenticated {
//            if authModel.registering {
                 
                
            EventsView(authModel: authModel, app: app!, eventsVM: eventsVM)
            let x = print("loaded from iCal")
            //let _ = authModel.setRegistration(value: false)
                
//            }
//            else {
//                EventsView(authModel: authModel, app: app!, eventsVM: getEventsFromDb())
//                let y = print("signed in - getting from DB")
//            }
        }
        else {
            if authModel.registering {
                
                
                let z = print("NOW WERE REGISTERING")
                RegistrationView(authModel: authModel, eventsViewModel: eventsVM)
                    .environmentObject(authModel)
            }
            else {
                let q = print("LOGIN VIEWWWWW")
                LoginView(eventsViewModel: eventsVM, vc: LoginViewController())
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
