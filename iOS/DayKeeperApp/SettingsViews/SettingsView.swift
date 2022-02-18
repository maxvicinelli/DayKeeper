//
//  SettingsView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/14/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var authModel: AuthenticationModel
    
    
    var body: some View {
        VStack {
            HStack {
                Button("Back"){
                    authModel.cancelSettings()
                }
                .padding()
                Spacer()
                Text("Settings")
                    .font(.title)
                Spacer()
            }
            
            NavigationView {
                List {
                    NavigationLink(
                        destination: AccountSettingsView(authModel: authModel),
                        label: {
                            AccountSettingsRow()
                        }
                    )
                    
                    NavigationLink(
                        destination: NotificationsSettingsView(),
                        label: {
                            NotificationsSettingsRow()
                        }
                    )
                    
                    // add in more for other settings we want
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(authModel: AuthenticationModel())
    }
}



