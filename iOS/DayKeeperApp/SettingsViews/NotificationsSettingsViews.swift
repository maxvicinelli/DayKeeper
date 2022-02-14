//
//  NotificationsSettingsViews.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/14/22.
//

import SwiftUI

struct NotificationsSettingsView: View {
    var body: some View {
        Text("Notification Settings here")
    }
}

struct NotificationsSettingsRow: View {
    var body: some View {
        HStack {
            Image("bell")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()

            Text("Notifications")


        }
    }
}

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView()
    }
}
