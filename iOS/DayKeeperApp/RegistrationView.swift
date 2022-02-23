//
//  RegistrationView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/3/22.
//

import SwiftUI

struct RegistrationView: View {
    
    //@ObservedObject var authModel: AuthenticationModel
    @ObservedObject var authModel: AuthenticationModel
    @ObservedObject var eventsViewModel: EventsViewModel
    
    @State var registrationFailed: Bool = false
    
    var body: some View {
        VStack {
        HStack{
                Button("Back"){
                    authModel.setRegistration(value: false)
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
                                eventsViewModel.loadFromiCal()
                                authModel.authenticated = true
                                
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
        RegistrationView(authModel: AuthenticationModel(), eventsViewModel: EventsViewModel())
           // .environmentObject(AuthenticationModel())
    }
}
