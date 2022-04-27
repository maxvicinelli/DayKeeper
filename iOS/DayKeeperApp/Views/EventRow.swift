//
//  EventRow.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/6/22.
//
import SwiftUI
import RealmSwift

struct EventRow: View {
    
    @State var event: Event
    @State var userGaveLateInput: Bool = false
    
    @State private var new_task = ""
    @State private var new_category = ""
    var actionNotificationManager: ActionNotifManager
    
    private func updateEvent() {
        print("update event:")
        print(new_task)
        if new_task != "" {
            print(new_task)
            //let pretask = Event()
          //  pretask.Title = new_task
            if let app = app {
                let user = app.currentUser
                let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
                try! realm.write{
                  
                    realm.add(event, update: .modified)
                    event.Tasks.append(new_task)
                }
            }
        }
        postEvent(event: event, updating: true)
        //reload page
    }
    
    
    private func manualLate() {
        actionNotificationManager.updateOtherEvents(event: self.event, early: false)
    }
    
    private func manualEarly() {
        actionNotificationManager.updateOtherEvents(event: self.event, early: true)
    }
    
    
    var body: some View {
        
//        let _ = print(event)
        VStack() {
            TextField(event.Title, text: $event.Title)
                .multilineTextAlignment(.center)
                .frame(width: 360, height: 80, alignment: .center)
                .multilineTextAlignment(.center)
            
                .shadow(radius: 15)
                .foregroundColor(Color.textColor)
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
                .background(Color(red:0.436, green: 0.558, blue: 0.925 ))
            
            TextField(event.Description, text: $event.Description)
                .frame(width: 330, height: 40)
                .multilineTextAlignment(.center)
                .background(RoundedRectangle(cornerRadius: 20).fill( Color(red: 0.996, green: 0.396, blue: 0.31)) )
                .shadow(radius: 5)
                .padding(.bottom, 15)
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
            
            let howEarly = event.OnTime + 2
            
            Text("You are currently being reminded \(howEarly) minutes early for this event")
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 14)!))
                .multilineTextAlignment(.center)
            
            
            VStack {
                DatePicker("Start Date", selection: $event.StartDate)
                
                
                DatePicker("End Date", selection: $event.EndDate)
                    .padding(.bottom, 15)
            }
            .padding()
            .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
            
            HStack {
                Button("I Was Early", action: manualEarly)
                //                    .frame(width: 100, height: 60)
                //                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                //                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
                
                Spacer()
                
                Button("I Was Late", action: manualLate)
                //                    .frame(width: 100, height: 60)
                //                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                //                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
            }
            
            
            Section(header:
                        Text("Tasks")
                        .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))) {
                if (event.Tasks != nil)
                {
                    ForEach(event.Tasks,  id: \.self)
                    { subEvent in
                        NavigationLink {
                           // EventRow(event: subEvent, actionNotificationManager: actionNotificationManager)
                        } label: {
                            //Text(subEvent.Title)
                            Text(subEvent)
                                .background(Color(red: 0.996, green: 0.396, blue: 0.31))
                        }
                    }
                }
                TextField("New Task", text: $new_task)
                TextField("Update Category", text: $new_category)
            }
            Button("Save", action: updateEvent)
            
            
                .frame(width: 330, height: 60, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
            
        }
        .frame(height: 900)
        .background(Color(red:0.436, green: 0.558, blue: 0.925))
        .padding(.bottom, 100)
    }
}








struct EventRow_Previews: PreviewProvider {
    //
    //    let newEvent = Event()
    //    let Title = "Happy hour"
    //
    //
    //    newEvent.Title = Title
    //    newEvent.Description = "Big chilling and sipping with the fellas"
    //    newEvent.StartDate = Date.now
    //    newEvent.EndDate = Date.now.addingTimeInterval(86400)
    //
    //    let category = Category()
    //    category.Title = "drinks"
    //    event.Category = category
    
    static var previews: some View {
        
        EventRow(event: Event(), actionNotificationManager: ActionNotifManager())
    }
}
