//
//  NotificationsSettingsViews.swift
//  DayKeeperApp
//
//  Created by Max Vicinelli on 2/14/22.
//

import SwiftUI

struct NotificationsSettingsView: View {
    var body: some View {
        ZStack {
            Color(red:0.436, green: 0.558, blue: 0.925)
            VStack(alignment: .leading) {
                Text("Notification Settings here")
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 30)!))
                    .foregroundColor(.textColor)
            }
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
            .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        }
        .ignoresSafeArea()
               
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
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
        }
    }
}

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView()
    }
}
