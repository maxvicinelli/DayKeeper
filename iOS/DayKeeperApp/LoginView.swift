//
//  LoginView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 1/30/22.
//

import SwiftUI
import UIKit

//let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
//
//let lightBlueColor = Color(red: 240.0/255.0, green: 248/255.0, blue: 255/255.0, opacity:  1.0)

// Extend Font to be able to use UIFont so that we can use the custom font
// Taken from: https://swiftuirecipes.com/blog/converting-between-uifont-and-swiftui-font
public extension Font {
  init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}

// Extend Color to be able to use a UIColor to color text/buttons
// Taken from https://stackoverflow.com/questions/56994464/how-to-convert-uicolor-to-swiftui-s-color
public extension Color {
    static let textColor = Color(UIColor(red: 0.961, green: 0.929, blue: 0.941, alpha: 1))
}

//struct FitToWidth: ViewModifier {
//    var fraction: CGFloat = 1.0
//    func body(content: Content) -> some View {
//        GeometryReader { g in
//        content
//            .font(.system(size: 1000))
//            .minimumScaleFactor(0.005)
//            .lineLimit(1)
//            .frame(width: g.size.width*self.fraction)
//        }
//    }
//}

struct LoginView: View {
//    backgroundColor = (Color(red:0.436, green: 0.558, blue: 0.925))
    //@ObservedObject var authModel: AuthenticationModel
    @EnvironmentObject var authModel: AuthenticationModel
    @ObservedObject var eventsViewModel: EventsViewModel
    @State var authenticationDidSucceed: Bool = false
    @State var authenticationDidFail: Bool = false
    var body: some View {
        ZStack {
            NavigationView {
                VStack() {
                    Text("")
                        .padding(.bottom, 35)
                    Image("alarm-resized")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
//                        .padding()
//                        .minimumScaleFactor(0.5)
//                                    .lineLimit(1)
                    
                    Text("DayKeeper")
                        .shadow(radius: 15)
                        .foregroundColor(Color.textColor)
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 60)!))
                        .padding(.vertical, 5.0)
                        .background(Color(red:0.436, green: 0.558, blue: 0.925 ))
                        .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                        
                    
                    TextField("Email", text: $authModel.email)
                        .padding()
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)) )
//                        .padding(.bottom, 20)
                        .shadow(radius: 5)
//                        .scaledToFill()
                    
                    SecureField("Password", text: $authModel.password)
                        .padding()
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 20).fill( Color(red:241/255, green: 231/255, blue: 159/255)) )
//                        .padding(.bottom, 20)
                        .shadow(radius: 5)
//                        .scaledToFill()
                    
                                      Button ("Sign In") {
                        print("recognized button press")
                        signIn(vm: authModel, onCompletion: { (success) in
                            
                            if (success) {
                                print("now loading events from DB")
                                eventsViewModel.loadFromDB()
                                print("finished loading from DB")
                                print("login success!")
                                authModel.setAuthenticated(value: true)
                            } else {
                                print("epic fail")
                                authenticationDidFail = true
                            }
                        })
                    }.font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 30)!))
                        .foregroundColor(.white)
                        .shadow(radius: 25)
                        .minimumScaleFactor(0.5)
                                    .lineLimit(1)

//                    Spacer()
//                        .frame(height:25)
                    
                    Button ("New Here?") {
                        authModel.setRegistration(value: true)
                        print("now beginning registration")
                    }
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 30)!))
                    .shadow(radius: 15)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
                                .lineLimit(1)
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
//        .modifier(FitToWidth(fraction: 1.0))
    }
        
//        .background(Color(red:0.436, green: 0.558, blue: 0.925))
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(eventsViewModel: EventsViewModel())
            .environmentObject(AuthenticationModel())
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
