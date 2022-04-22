//
//  CreateEventView.swift
//  DayKeeperApp
//
//  Created by Jonah Kershen on 2/20/22.
//

import SwiftUI
import RealmSwift

struct CreateEventView: View {
    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date() + (60 * 60)
    @Binding var isPresented: Bool
    // @State var actionNotificationManager: ActionNotifManager
    @ObservedObject var eventsVM: EventsViewModel
    
    
    func addEventToRealm() {
        
        print("called add event to realm!")
        
        let event = Event()
        event._id = UUID().uuidString
        event.UserId = userid
        event.Title = title
        event.StartDate = startDate
        event.EndDate = endDate
        event.Description = "desc"
        event.OnTime = -1
        event.NotifBefore = -1
        event.Tasks = RealmSwift.List<Event>()
        event.CreationMethod = ManualCreation
        
        let cat = Category()
        cat.Title = "Manually Created Event"
        event.Category = cat
        
        print("now adding event to realm")
        
        eventsVM.events.append(event)
        
        postEvent(event: event, updating: false) // might need to turn that update parameter off in postEvent. Also could need more info for the event
        
        // actionNotificationManager.createStatusUpdateNotifs()
        
        print("finished posting event!")
        
    }
    
    var body: some View {
        List {
            Section {
                VStack {
                    Text("Create Event")
                        .foregroundColor(Color.white)
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 40)!))
                    VStack {
                        TextField("Title", text: $title)
                        Spacer()
                        DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                        DatePicker("", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                    }
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    
                    
                    .cornerRadius(10)
                    Button {
                        DispatchQueue.main.async {
                            addEventToRealm()
                            self.isPresented = false
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
//        .onDisappear{
//            // not sure if this will be needed. With this method, we refresh the EventsView page using the notifications that are currently in the queue. maybe this is better than pulling everything from database tho? We need to discuss -- Jonah, 2/20/22
//            notificationManager.reloadLocalNotifications()
        //}
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
        CreateEventView(isPresented: .constant(false), eventsVM: EventsViewModel())
    }
}
