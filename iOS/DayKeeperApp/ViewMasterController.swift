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
        if authModel.authenticated {
            EventsView(app: app!, eventsVM: getEventsFromDb())//loadFromiCal(eventStore: store, eventsVM: eventsVM))
        } else {
            LoginView()
                .environmentObject(authModel)
        }
        
    }
}

struct ViewMasterController_Previews: PreviewProvider {
    static var previews: some View {
        ViewMasterController(authModel: AuthenticationModel())
    }
}
