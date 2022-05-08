//
//  ChildSettingsView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/8/22.
//

import SwiftUI



struct ChildSettingsView: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    
    var body: some View {
        VStack {
            
           Text("Child Settings")
            
        
            ListRowView(toggleVar: $settingsViewModel.canLocationTrack, title: "Location Tracking")
            
            ListRowView(toggleVar: $settingsViewModel.canCreateEvents, title: "Event Creation")
               
            
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


struct ListRowView: View {
    var toggleVar: Binding<Bool>
    var title: String
    
    var body: some View {
        HStack {
            Text(title)

            Toggle(isOn: toggleVar) {

            }
        }
    }
}




struct ChildSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChildSettingsView(settingsViewModel: SettingsViewModel())
    }
}
