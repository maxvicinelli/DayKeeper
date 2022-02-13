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
            TextField("username", text: $authModel.username)
            
            TextField("email", text: $authModel.email)
            
            SecureField("password", text: $authModel.password)
            
            
            Button ("Create Account") {
                registerUser(vm: authModel, onCompletion: { (success) in
                    if (success) {
                        print("Creating the following account: ")
                        print("username \(authModel.username)")
                        print("email \(authModel.email)")
                        print("password \(authModel.password)")
                        authModel.authenticated = true
                    } else {
                        print("Did not create")
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
