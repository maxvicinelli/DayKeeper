//
//  ContentView.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 1/28/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ViewMasterController(authModel: AuthenticationModel(), eventsVM: EventsViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
