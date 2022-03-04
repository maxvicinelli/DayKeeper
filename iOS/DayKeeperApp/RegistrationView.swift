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
        
        ZStack {
            
            VStack{
                Text("Welcome")
                    .font(Font.custom("Helvetica", size: 60))
                    .foregroundColor(Color.white)
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/10)
            }
            VStack{
                //TextField("username", text: $authModel.username)
                TextField("email", text: $authModel.email)
                    .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)) )
        
                    .frame(width: 330, alignment: .center)
                    .padding(30)
                
                SecureField("password", text: $authModel.password)
                    .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)))
                    .frame(width: 330, alignment: .center)
                
                if registrationFailed {
                    Text("registration failed")
                }
                
            }
            
            
            Button(action: {authModel.setRegistration(value: false)},
                   label: {Image(systemName: "arrow.left").renderingMode(.original)}
            )
                .padding()
                .background(Color(red: 1, green: 1, blue: 1))
                .clipShape(Circle())
                .position(x: UIScreen.main.bounds.width/10, y: UIScreen.main.bounds.height*9/10)
            
            
            Button ( action: {
                
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
            }, label:{Image(systemName: "arrow.right").renderingMode(.original)})
                .padding()
                .background(Color(red: 1, green: 1, blue: 1))
                .clipShape(Circle())
                .position(x: UIScreen.main.bounds.width*9/10, y: UIScreen.main.bounds.height*9/10)
            
        }.background(Color(red:0.436, green: 0.558, blue: 0.925))
    }
}

struct RegistrationView_Previews: PreviewProvider {
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    static var previews: some View {
        RegistrationView(authModel: AuthenticationModel(), eventsViewModel: EventsViewModel())
        // .environmentObject(AuthenticationModel())
        
    }
}
