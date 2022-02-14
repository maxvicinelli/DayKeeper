//
//  AccountSettingsView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/14/22.
//

import SwiftUI


struct AccountSettingsView: View {
    
    @ObservedObject var authModel: AuthenticationModel
    
    var body: some View {
        
        VStack {
        
            HStack {
                Text("Account Settings")
                
                Button("done") {
                    print("updated settings")
                    // here we'll call a method that updates the settings 
                }
            }
            
            
            
            VStack {
                TextField(
                    authModel.username,
                    text: $authModel.username
                )
                SecureField(
                    authModel.password,
                    text: $authModel.password
                )
                TextField(
                    authModel.email,
                    text: $authModel.email
                )
            }
        }
        
    }
}

struct AccountSettingsRow: View {
    var body: some View {
        HStack {
            Image("user")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()

            Text("Account")


        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView(authModel: AuthenticationModel())
    }
}
