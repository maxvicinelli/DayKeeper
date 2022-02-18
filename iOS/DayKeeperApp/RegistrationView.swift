//
//  RegistrationView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/3/22.
//

import SwiftUI

struct RegistrationView: View {
    
    //@ObservedObject var authModel: AuthenticationModel
    @EnvironmentObject var authModel: AuthenticationModel
    
    @State var registrationFailed: Bool = false
    
    var body: some View {
        VStack {
        HStack{
                Button("Back"){
                    authModel.cancelRegistration()
                }
            }
            //TextField("username", text: $authModel.username)
            TextField("email", text: $authModel.email)
            SecureField("password", text: $authModel.password)
            
            Button ("Create Account") {
                registerUser(vm: authModel, onCompletion: { (registerSuccess) in
                    if (registerSuccess) {
                        signIn(vm: authModel, onCompletion: { (signInSuccess) in
                            if (signInSuccess) {
                                authModel.authenticated = true
                                authModel.registering = true
                            }
                        })
                    } else {
                        registrationFailed = true
                    }
                })
            }
            
            
            if registrationFailed {
                Text("registration failed")
            }
            
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthenticationModel())
    }
}
