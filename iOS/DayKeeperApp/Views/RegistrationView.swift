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
                    .shadow(radius: 15)
                    .foregroundColor(Color.textColor)
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 60)!))
                    .padding(.vertical, 5.0)
                    .background(Color(red:0.436, green: 0.558, blue: 0.925 ))
                    .minimumScaleFactor(0.5)
                                .lineLimit(1)
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/10)
            }
            VStack{
                //TextField("username", text: $authModel.username)
                TextField("email", text: $authModel.email)
                  .padding()
                    .multilineTextAlignment(.center)
                    .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)) )
                        .padding(15)
                    .shadow(radius: 5)
//                        .scaledToFill()
                
                SecureField("password", text: $authModel.password)
                    .padding()
                    .multilineTextAlignment(.center)
                    .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)) )
                        .padding(15)
                    .shadow(radius: 5)
//                        .scaledToFill()
                
                if registrationFailed {
                    Text("registration failed")
                }
                
                Toggle(isOn: $authModel.parentAccout) {
                    Text("Parent Account")
                    let _ = print(authModel.parentAccout)
                }
                
            }
            
            
            Button(action:
                    {
                withAnimation(.easeInOut) {
                    authModel.setRegistration(value: false)
                }
            },
                    label: {Image(systemName: "arrow.left").renderingMode(.original)}
            )
                .padding()
                .background(Color(red: 1, green: 1, blue: 1))
                .clipShape(Circle())
                .position(x: UIScreen.main.bounds.width/10, y: UIScreen.main.bounds.height*9/10)
            
            
            Button ( action: {
                
                registerUser(vm: authModel, onCompletion: { (registerSuccess) in
                    if (registerSuccess) {
                        withAnimation(.easeInOut){
                            signIn(vm: authModel, onCompletion: { (signInSuccess) in
                                if (signInSuccess) {
                                    print("loading from iCal")
                                    eventsViewModel.loadFromiCal(registering: true)
                                    print("sending to realm")
                                    authModel.authenticated = true
                                    
                                }
                            })
                        }
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
