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
        else if authModel.authenticated {
            EventView(events: dummyEvents(), authModel: authModel)//MainView()
        }
        else {
            if authModel.registering {
                RegistrationView(authModel: authModel)
            } else {
                LoginView(authModel: authModel)
            }
        }
        
    }
}

struct ViewMasterController_Previews: PreviewProvider {
    static var previews: some View {
        ViewMasterController(authModel: AuthenticationModel())
    }
}
