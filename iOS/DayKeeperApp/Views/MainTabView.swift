//
//  MainTabView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 4/19/22.
//

import SwiftUI

struct MainTabView: View {
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
            EventsView(authModelParam: authModel, appParam: app!, eventsVMParams: eventsVM, settingsVMParam: settingsVM)
                .tabItem {
                    Label("Events", systemImage: "list.dash")
                }
                .tag(0)
            
            StatsView(eventsVMParam: eventsVM)
                .tabItem {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                }
                .tag(1)
            SettingsView(authModelParam: authModel, settingsViewModelParam: settingsVM)

                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
            
            HelpView()
                .tabItem {
                    Label("Help", systemImage: "questionmark")
                }
                .tag(3)
        }
        .accentColor(Color("Off-White"))
        //.tabViewStyle(PageTabViewStyle())
        //.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .background(Color(red:0.436, green: 0.558, blue: 0.925))
        //.onAppear() {
        //    UITabBar.appearance().barTintColor = .white
       // }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(authModelParam: AuthenticationModel(), eventsVMParam: EventsViewModel(), settingsVMParam: SettingsViewModel())
    }
}
