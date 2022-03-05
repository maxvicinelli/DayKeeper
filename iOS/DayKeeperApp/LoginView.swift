//
//  LoginView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 1/30/22.
//

import SwiftUI
import UIKit

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let lightBlueColor = Color(red: 240.0/255.0, green: 248/255.0, blue: 255/255.0, opacity:  1.0)

// Extend Font to be able to use UIFont so that we can use the custom font
// Taken from:  https://swiftuirecipes.com/blog/converting-between-uifont-and-swiftui-font
public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}

struct LoginView: View {
//    backgroundColor = (Color(red:0.436, green: 0.558, blue: 0.925))
    //@ObservedObject var authModel: AuthenticationModel
    @EnvironmentObject var authModel: AuthenticationModel
    @ObservedObject var eventsViewModel: EventsViewModel
    @State var authenticationDidSucceed: Bool = false
    @State var authenticationDidFail: Bool = false
    var vc : LoginViewController
    var body: some View {
//        vc.loadView()
//        (Color(red:0.436, green: 0.558, blue: 0.925)).ignoresSafeArea()
        ZStack {
            NavigationView {
                VStack() {
                    Text("DayKeeper")
                        .foregroundColor(Color.white)
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 60)!))
                        .padding(.vertical, 15.0)
                        .background(Color(red:0.436, green: 0.558, blue: 0.925 ))
//                        .font(.largeTitle)
                    
                    
                    TextField("email", text: $authModel.email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)) )
                        .border(Color.blue)
                        .padding(.bottom, 20)
                    
                    SecureField("password", text: $authModel.password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)) )
                        .border(Color.blue)
                        .padding(.bottom, 20)
                    
                    Button ("Sign In") {
                        print("recognized button press")
                        signIn(vm: authModel, onCompletion: { (success) in
                            print("now loading events from DB")
                            eventsViewModel.loadFromDB()
                            print("finished loading from DB")
                            if (success) {
                                print("login success!")
                                authModel.setAuthenticated(value: true)
                            } else {
                                print("epic fail")
                                authenticationDidFail = true
                            }
                        })
                    }
//                    vc.loadView()
                    Button ("Register") {
                        authModel.setRegistration(value: true)
                        print("now beginning registration")
                    }
                    if authenticationDidFail {
                        Text("auth failed")
                    }

                }
                .padding(.bottom, 200.0)
                .background(Color(red:0.436, green: 0.558, blue: 0.925))
            }
            .padding()
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
        }
        .background(Color(red:0.436, green: 0.558, blue: 0.925))
    }
//        .background(Color(red:0.436, green: 0.558, blue: 0.925))
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(eventsViewModel: EventsViewModel(), vc: LoginViewController())
            .environmentObject(AuthenticationModel())
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
