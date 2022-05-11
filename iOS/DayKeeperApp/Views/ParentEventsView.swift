//
//  ParentEventsView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/10/22.
//

import SwiftUI
import RealmSwift

struct ParentEventsView: View {
    
    @ObservedObject var authModel: AuthenticationModel
    @ObservedObject var app: RealmSwift.App
    @ObservedObject var settingsVM: SettingsViewModel
    
    
    var body: some View {
        if settingsVM.authorized {
            EventsView(authModelParam: authModel, appParam: app, eventsVMParams: settingsVM.childEVM, settingsVMParam: settingsVM)
        } else {
            ZStack {
                Text("Please pair child account to view events")
            }
        }
    }
}

struct ParentEventsView_Previews: PreviewProvider {
    static var previews: some View {
        ParentEventsView(authModel: AuthenticationModel(), app: app!, settingsVM: SettingsViewModel())
    }
}
