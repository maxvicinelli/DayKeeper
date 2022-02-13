//
//  ViewMasterController.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/2/22.
//

import SwiftUI

struct ViewMasterController: View {
    
    @ObservedObject var authModel: AuthenticationModel
    
    var body: some View {
        
        if authModel.viewingSettings {
            SettingsView(authModel: authModel)
        }
      

        if authModel.authenticated {
            EventView(authModel: authModel, app: app!, events: loadFromiCal())
        } else {

            if authModel.registering {
                RegistrationView()
                    .environmentObject(authModel)
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
