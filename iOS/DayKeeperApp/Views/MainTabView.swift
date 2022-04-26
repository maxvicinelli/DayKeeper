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
    
    
    init(authModelParam: AuthenticationModel, eventsVMParam: EventsViewModel ){
        self.authModel = authModelParam
        self.eventsVM = eventsVMParam
        UITabBarAppearance().backgroundColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            EventsView(authModelParam: authModel, appParam: app!, eventsVMParams: eventsVM)
                .tabItem {
                    Label("Events", systemImage: "list.dash")
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                }
            SettingsView(authModelParam: authModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            HelpView()
                .tabItem {
                    Label("Help", systemImage: "questionmark")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(authModelParam: AuthenticationModel(), eventsVMParam: EventsViewModel())
    }
}