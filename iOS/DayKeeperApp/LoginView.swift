//
//  LoginView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 1/30/22.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let lightBlueColor = Color(red: 240.0/255.0, green: 248/255.0, blue: 255/255.0, opacity:  1.0)

struct LoginView: View {
    
    //@ObservedObject var authModel: AuthenticationModel
    @EnvironmentObject var authModel: AuthenticationModel
    @ObservedObject var eventsViewModel: EventsViewModel
    @State var authenticationDidSucceed: Bool = false
    @State var authenticationDidFail: Bool = false
    
    var body: some View {
        NavigationView {
            VStack() {
                Text("DayKeeper")
                    .padding(.vertical, 15.0)
                    .font(.largeTitle)
                
                
                TextField("email", text: $authModel.email)
                    .padding()
                    .border(Color.blue)
                    .padding(.bottom, 20)
                
                SecureField("password", text: $authModel.password)
                    .padding()
                    .border(Color.blue)
                    .padding(.bottom, 20)
                
                Button ("Sign In") {
                    signIn(vm: authModel, onCompletion: { (success) in
                        eventsViewModel.updateEvents()
                        if (success) {
                            authModel.authenticated = true
                        } else {
                            authenticationDidFail = true
                        }
                    })
                }
                Button ("Register") {
                    authModel.setRegistration(value: true)
                    print("now beginning registration")
                }
                if authenticationDidFail {
                    Text("auth failed")
                }
                
//                NavigationLink(destination: RegistrationView()
//                                    .environmentObject(authModel)) {
//                    Text("Register")
//
//                }
            }
            .padding(.bottom, 200.0)
            
        }
        .padding()

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(eventsViewModel: EventsViewModel())
            .environmentObject(AuthenticationModel())
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
