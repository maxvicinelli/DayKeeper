//
//  CreateEventView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/20/22.
//

import SwiftUI

struct CreateEventView: View {
    @State private var title = ""
    @State private var date = Date()
    @Binding var isPresented: Bool
    @ObservedObject var notificationManager: NotificationManager
    
    var body: some View {
        List {
            Section {
                VStack {
                    HStack {
                        TextField("Event Title", text: $title)
                        Spacer()
                        DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .cornerRadius(5)
                    Button {
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                        guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day, let hour = dateComponents.hour, let minute = dateComponents.minute else { return }
                        notificationManager.createLocalNotifications(title: title, year: year, month: month, day: day, hour: hour, minute: minute) { error in
                            if error == nil {
                                DispatchQueue.main.async {
                                    self.isPresented = false
                                }
                            }
                        }
                        
                    } label: {
                        Text("Create")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .buttonStyle(PlainButtonStyle())
                }
                .listRowBackground(Color(.systemGroupedBackground))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onDisappear{
            // not sure if this will be needed. With this method, we refresh the EventsView page using the notifications that are currently in the queue. maybe this is better than pulling everything from database tho? We need to discuss -- Jonah, 2/20/22
            notificationManager.reloadLocalNotifications()
        }
        .navigationTitle("Create Event")
        .navigationBarItems(trailing: Button {
            isPresented = false
        } label: {
            Image(systemName: "xmark")
                .imageScale(.large)
        })
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView(isPresented: .constant(false), notificationManager: NotificationManager())
    }
}
