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
        
        VStack {
        
        
            TextField(settingsViewModel.childEmail, text: $settingsViewModel.childEmail)
                .frame(width: 300, height: 40, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
            
            Button("Add Child", action: settingsViewModel.addChild)
                .padding()
                .frame(width: 300, height: 40, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                .buttonStyle(PlainButtonStyle())
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
                .multilineTextAlignment(.center)
        }
        .frame(width: 1000, height: 1000, alignment: .center)
        .background(Color(UIColor(named: "Back-Blue")!))
            
        
    }
}

struct AddChildrenRow: View {
    var body: some View {
        HStack {
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
