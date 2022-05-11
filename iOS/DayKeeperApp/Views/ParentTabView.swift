//
//  ParentTabView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 5/9/22.
//

import SwiftUI

struct ParentTabView: View {
    @ObservedObject var authModel: AuthenticationModel
    @ObservedObject var eventsVM: EventsViewModel
    @ObservedObject var settingsVM: SettingsViewModel
    
    
    init(authModelParam: AuthenticationModel, eventsVMParam: EventsViewModel, settingsVMParam: SettingsViewModel ){
        self.authModel = authModelParam
        self.eventsVM = eventsVMParam
        self.settingsVM = settingsVMParam
        UITabBarAppearance().backgroundColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            
            
            StatsView(eventsVMParam: settingsVM.childEVM)
                .tabItem {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                }
                .tag(0)
            SettingsView(authModelParam: authModel, settingsViewModelParam: settingsVM)

                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(1)
            
            HelpView()
                .tabItem {
                    Label("Help", systemImage: "questionmark")
                }
                .tag(2)
            
            
           
            ParentEventsView(authModel: authModel, app: app!, settingsVM: settingsVM)
                .tabItem {
                    Label("Child Events", systemImage: "list.dash")
                }
                .tag(3)
            
        }
        .accentColor(Color("Off-White"))
        //.onAppear() {
        //    UITabBar.appearance().barTintColor = .white
       // }
    }
}

struct ParentTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(authModelParam: AuthenticationModel(), eventsVMParam: EventsViewModel(), settingsVMParam: SettingsViewModel())
    }
}
