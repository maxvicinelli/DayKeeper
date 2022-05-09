//
//  ChildAcctSettingsView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/9/22.
//

import SwiftUI



struct ChildAcctSettingsView: View {
    
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        
        
        if settingsViewModel.parentEmail == "" {
            ZStack {
                Text("No parent account associated with this account")
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            }
            .padding()
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .center
                )
            .background(Color(UIColor(named: "Back-Blue")!))
        } else {
            VStack {
                Text("The parent email linked to this account is: ")
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                Text(settingsViewModel.parentEmail)
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            }
            .padding()
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .center
                )
            .background(Color(UIColor(named: "Back-Blue")!))
            
        }
       
    }
}

struct ChildAcctSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChildAcctSettingsView(settingsViewModel: SettingsViewModel())
    }
}
