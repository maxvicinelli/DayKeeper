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
        postEvent(event: event)
    }
        
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
               .font(.title)
            TextField(event.Title, text: $event.Title)
            
            Text("Description")
             .font(.subheadline)
            TextField(event.Description, text: $event.Description)
               
            //List {
                Section(header: Text("Properties")) {
                    
                    
                    
                    
                    
//                    if event.Category != nil {
//                        Text("Category")
//                            .bold()
//
//                        TextField(event.Category?.Title, text: $event.Category.Title)
//                    }
                        
                    
                    DatePicker("Start Date", selection: $event.StartDate)
                   
                    DatePicker("End Date", selection: $event.EndDate)
                    Text("Recurrence")
                        .bold()
                    Text(/*event.Category?.Cadence ?? */"NEVER")
  
//                    Toggle(isOn: $event.NotifBefore) {
//                        Text("Notify me before")
//                            .bold()
//                    }
<<<<<<< HEAD
=======
                    
                    
                    
>>>>>>> 1385538 (cleanup before merging to main)
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
    static var previews: some View {
       
        EventRow(event: Event())
    }
}
