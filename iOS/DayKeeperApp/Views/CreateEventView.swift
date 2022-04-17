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
                    Text("Create Event")
                        .foregroundColor(Color.white)
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 40)!))
                    HStack {
                        TextField("Title", text: $title)
                        Spacer()
                        DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    }
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    
                    
                    .cornerRadius(10)
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
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                    .buttonStyle(PlainButtonStyle())
                }
             .listRowBackground(Color(red:0.436, green: 0.558, blue: 0.925))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onDisappear{
            // not sure if this will be needed. With this method, we refresh the EventsView page using the notifications that are currently in the queue. maybe this is better than pulling everything from database tho? We need to discuss -- Jonah, 2/20/22
            notificationManager.reloadLocalNotifications()
        }
      //  .navigationTitle("Create Event")
        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
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
