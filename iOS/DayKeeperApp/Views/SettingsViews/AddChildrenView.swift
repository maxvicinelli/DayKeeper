//
//  AddChildrenView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/2/22.
//

import SwiftUI


struct AddChildrenView: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        
        if settingsViewModel.authorized {
            VStack {
                Text("You are paired with \(settingsViewModel.childEmail)")
                    .padding()
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
            .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            .background(Color(UIColor(named: "Back-Blue")!))
        } else {
        
        
            VStack {
            
            
                TextField("Child's Email", text: $settingsViewModel.childEmail)
                    .frame(width: 330, height: 40, alignment: .center)
                    .multilineTextAlignment(.center)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
    //                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
                SecureField("Child's Password", text: $settingsViewModel.childPassword)
                    .frame(width: 330, height: 40, alignment: .center)
                    .multilineTextAlignment(.center)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
    //                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
                Button("Add Child", action: settingsViewModel.addChild)
                    .padding()
                    .frame(width: 330, height: 40, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                    .buttonStyle(PlainButtonStyle())
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 1000, height: 1000, alignment: .center)
            .background(Color(UIColor(named: "Back-Blue")!))
        }
        
    }
}

struct AddChildrenRow: View {
    var body: some View {
        HStack {
            Image("children")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            Text("Add Children")
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
        }
    }
}

struct AddChildrenView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildrenView(settingsViewModel: SettingsViewModel())
    }
}
