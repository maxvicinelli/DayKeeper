//
//  NotifResponseView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/27/22.
//

import SwiftUI

struct NotifResponseView: View {
    let notificationTitle: String
    let eventStartDate: Date
    
    var body: some View {
        VStack {
            Text(notificationTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Text(eventStartDate, style: .date)
            Text(eventStartDate, style: .time)
            HStack {
                Button("Early") {
                    // send response to database as is done when they use the actionable notification with app in background
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(5)
            }
//            Button("On Time") {
//
//            }
//            .padding()
//            .background(Color(.systemGray5))
//            .cornerRadius(5)
            Button("Late") {
                
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(5)

        }
        .padding()
    }
}

struct NotifResponseView_Previews: PreviewProvider {
    static var previews: some View {
        NotifResponseView(notificationTitle: "meeting with professor", eventStartDate: Date())
    }
}
