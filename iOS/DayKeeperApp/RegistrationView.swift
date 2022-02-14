//
//  RegistrationView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/3/22.
//

import SwiftUI

struct RegistrationView: View {
    
    @ObservedObject var authModel: AuthenticationModel
    
    
    @State var registrationFailed: Bool = false
    
    var body: some View {
        VStack {
            HStack{
                Button("Back"){
                    authModel.cancelRegistration()
                }
            }
            TextField("username", text: $authModel.username)
            
            TextField("email", text: $authModel.email)
            
            SecureField("password", text: $authModel.password)
            
            
            Button ("Create Account") {
                if !authModel.attemptRegistration() {
                    registrationFailed = true
                }
            }
            
            
            if registrationFailed {
                Text("registration failed")
            }
            
            
            
            
            
            
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(authModel: AuthenticationModel())
    }
}
