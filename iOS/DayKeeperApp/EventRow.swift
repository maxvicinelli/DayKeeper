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
    
    private func updateEvent() {
        print(event)
        
        // here is where we will send the event to the DB
        // need to make sure that we're grabbing from DB each time we open main view
        // use viewDidAppear()
    }
    
    
    //@ObservedRealmObject var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
               .font(.title)
            TextField(event.Title, text: $event.Title)
            
            Text("Description")
            // .font(.subheadline)
            TextField(event.Description, text: $event.Description)
               
            //List {
                Section(header: Text("Properties")) {
                    
                    
//                    Text("Category")
//                    TextField(event.Category?.Title, text: $event.Category.Title)
                        //.bold()
                    Text(/*event.Category?.Title ?? */"No title")
                    
                    DatePicker("Start Date", selection: $event.StartDate)
                   
                    DatePicker("End Date", selection: $event.EndDate)
                    Text("Recurrence")
                        .bold()
                    Text(/*event.Category?.Cadence ?? */"NEVER")
  
//                    Toggle(isOn: $event.NotifBefore) {
//                        Text("Notify me before")
//                            .bold()
//                    }
                }.headerProminence(.increased)
                Section(header: Text("Tasks")) {
                    if (event.Tasks != nil)
                    {
                        ForEach(event.Tasks!)
                        { task in
                            NavigationLink {
                                TaskRow(task: task)
                            } label: {
                                Text(task.Title)
                            }
                        }
                    }
                }
            Button("Save", action: updateEvent)
            }
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
       
        EventRow(event: Event())
    }
}
