//
//  AccountSettingsView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/14/22.
//

import SwiftUI


struct AccountSettingsView: View {
    
    @ObservedObject var authModel: AuthenticationModel
    
    var body: some View {
        
        ZStack {
            Color(red:0.436, green: 0.558, blue: 0.925)
            VStack {
                Spacer()
                HStack {
                    Text("Account Settings")
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 30)!))
                        .foregroundColor(.textColor)
                    Button("done") {
                        print("updated settings")
                        // here we'll call a method that updates the settings
                    }
                }
                
                
                
                VStack {
    //                TextField(
    //                    authModel.username,
    //                    text: $authModel.username
    //                )
                    SecureField(
                        authModel.password,
                        text: $authModel.password
                    )
                    TextField(
                        authModel.email,
                        text: $authModel.email
                    )
                }
                Spacer()
            }
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .ignoresSafeArea()
    }
}

struct AccountSettingsRow: View {
    var body: some View {
        HStack {
            Image("user")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            
//            if let image_url = Bundle.main.url(forResource: "user", withExtension: "png") {
//                Image(uiImage: UIImage(imageLiteralResourceName: image_url.lastPathComponent))
//                    .renderingMode(.original)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .padding()
//            }

            Text("Account")
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView(authModel: AuthenticationModel())
    }
}
