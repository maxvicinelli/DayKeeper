//
//  RegistrationView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/3/22.
//

import SwiftUI

struct RegistrationView: View {
    
    @ObservedObject var authModel: AuthenticationModel
    
    var body: some View {
        VStack {
            TextField("username", text: $authModel.username)
            
            TextField("email", text: $authModel.email)
            
            SecureField("password", text: $authModel.password)
            
            
            Button("Import iCalendar", action: authModel.attemptRegistration)
            
            
            
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(authModel: AuthenticationModel())
    }
}
