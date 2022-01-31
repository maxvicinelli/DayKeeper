//
//  LoginView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 1/30/22.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            VStack() {
                Text("DayKeeper")
                    .padding(.vertical, 15.0)
                    .font(.largeTitle)
            
                    
                NavigationLink (
                    destination: MainView(),
                    label: {
                        
                        Text("Sign in")
                            .fontWeight(.thin)
                            .frame(width: 200.0, height: 40.0)
                            .border(Color.blue)

                    })
                    .padding(.bottom, 5)
            
                    
                NavigationLink (
                    destination: MainView(),
                    label: {
                        
                        Text("Register")
                            .fontWeight(.thin)
                            .frame(width: 200.0, height: 40.0)
                            .border(Color.blue)

                    })
                
            }
            .padding(.bottom, 200.0)
            
        }
        .padding()
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
