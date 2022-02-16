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
    var store = EKEventStore()
    var body: some View {
        if authModel.authenticated {
            EventsView(app: app!, events: dummyEvents())//loadFromiCal(eventStore: store))
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
