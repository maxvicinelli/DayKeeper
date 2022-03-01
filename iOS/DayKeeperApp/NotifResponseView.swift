//
//  NotifResponseView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/27/22.
//

import SwiftUI

struct NotifResponseView: View {
    @Binding var isPresented: Bool
    let notificationTitle: String
    let eventStartDate: Date
    var actionNotifManger = ActionNotifManager()
    
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
                    if let event = getEventsFromDb().first(where: {$0.Title == notificationTitle}) {
                        actionNotifManger.updateOtherEvents(event: event, early: true)
                    }
                    isPresented = false
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
                if let event = getEventsFromDb().first(where: {$0.Title == notificationTitle}) {
                    actionNotifManger.updateOtherEvents(event: event, early: false)
                }
                isPresented = false
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(5)

        }
        .padding()
    }
}

//struct NotifResponseView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotifResponseView(isPresented: $True, notificationTitle: "meeting with professor", eventStartDate: Date())
//    }
//}
