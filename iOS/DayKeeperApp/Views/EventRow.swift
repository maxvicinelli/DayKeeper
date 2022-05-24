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
//    @State private var latitude = 0.0
//    @State private var longitude = 0.0
//    @State private var address = ""
    var actionNotificationManager: ActionNotifManager
    
    private func updateEvent() {
//        print("update event:")
//        print(new_task)
        if new_task != "" {
//            print("new task is:", new_task)
            //let pretask = Event()
          //  pretask.Title = new_task
            if let app = app {
                let user = app.currentUser
                let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
                try! realm.write{
                    event.Tasks.append(new_task)
                    realm.add(event, update: .modified)
//                    print("adding event to realm with these tasks:", event.Tasks)
                }
            }
        }
        if new_category != "" {
//            print("new category is:", new_category)
//            print("userid is:", userid)
            if let app = app {
                let user = app.currentUser
                let realm = try! Realm(configuration: (user?.configuration(partitionValue: user!.id))!)
                try! realm.write{
                    let category_obj = Category()
                    category_obj.UserId = userid
                    category_obj.Title = new_category
                    category_obj.Description = new_category
                    category_obj.Cadence = "Undetermined"
                    event.Category = category_obj
                    realm.add(event, update: .modified)
//                    print("adding event to realm with this new category:", event.Category?.Title)
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
       
            
        
        
        //let _ = print("printing event \(event)")
        VStack {
            
            
            
            let x = print("PRINTING EVENT")
            let _ = print(event)
            //if !event.isInvalidated {
            TextField(event.Title, text: $event.Title)
                .multilineTextAlignment(.center)
                .frame(width: 360, height: 80, alignment: .center)
                .multilineTextAlignment(.center)
            
                .shadow(radius: 15)
                .foregroundColor(Color.textColor)
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
                .background(Color(red:0.436, green: 0.558, blue: 0.925 ))
            
//            TextField(event.Description, text: $event.Description)
//                .frame(width: 330, height: 40)
//                .multilineTextAlignment(.center)
//                .background(RoundedRectangle(cornerRadius: 20).fill( Color(red: 0.996, green: 0.396, blue: 0.31)) )
//                .shadow(radius: 5)
//                .padding(.bottom, 15)
//                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
            
            let howEarly = event.OnTime + 2
            
            Text("You are currently being reminded \(howEarly) minutes early for this event")
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 14)!))
                .multilineTextAlignment(.center)
            
            
            VStack {
                DatePicker("Start Date", selection: $event.StartDate)
                
                
                DatePicker("End Date", selection: $event.EndDate)
                    .padding(.bottom, 15)
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
            
            HStack {
                Button("I Was Early", action: manualEarly)
                    .frame(width: 160, height: 60)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(UIColor(named: "Bubble-Yellow")!)))
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
                    .foregroundColor(Color.black)
                    .padding()
                
                
                
                
                Button("I Was Late", action: manualLate)
                    .frame(width: 160, height: 60)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(UIColor(named: "Bubble-Yellow")!)))
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
                    .foregroundColor(Color.black)
                    .padding()
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
//            NavigationLink (
//                destination: MapView(event: event),
//                label: {
//                    Text("Click to add an address for this event.")
//                        .frame(width: 350, height: 45, alignment: .center)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor(named: "Icon-Red")!)))
//                        //.font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
//                        .foregroundColor(Color.black)
//                })
            
            
            HStack {
                VStack (alignment: .leading) {
                    Text("Address:")
                       
                        
                    Text(event.Location)
                        
                       
                }
                
                
            
               
                .padding(.leading, 10)
                Spacer()
                NavigationLink (
                    destination: MapView(event: event),
                    label: {
                        Image("arrow")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor(named: "Icon-Red")!)))
//                            //.font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 16)!))
//                            .foregroundColor(Color.black)
                    })
            }
            .frame(width: 360, height: 64, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor(named: "Icon-Red")!)))
            .multilineTextAlignment(.leading)
            .padding(.bottom, 15)
            //.frame(width: 400, height: 70, alignment: .center)
//            Section(header: Text("Address").font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))){
//                Text(event.Location)
//                    //.padding(.top, 3)
//            }
            
            VStack {
                
                HStack {
                    ZStack (alignment: .leading) {
                        Text("Category").font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                    }
                    .padding(.leading, 15)
                    Spacer()
                    
                    ZStack (alignment: .trailing) {
                        Text("Tasks").font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                    }
                    .padding(.trailing, 28)
                    
                }
            
            
                HStack {
                    VStack (alignment: .leading) {
                        //Text("Category").font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                        if event.Category?.Title != "" {
                            Text(event.Category?.Title ?? "")
                        } else {
                            Text("None")
                        }
                        TextField("New Task", text: $new_task)
                            //.padding(.leading, 15)

                        TextField("Update Category", text: $new_category)
                           // .padding(.leading, 15)
                        
                    }
                    .padding(.leading, 15)
                    VStack (alignment: .trailing) {
                        //Text("Tasks").font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
                        if (event.Tasks.count > 0) {
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
                    }
                    .padding(.trailing, 15)
                    .padding(.bottom, 20)
                }
            }
            
            Button("Save", action: updateEvent)
            
            
                .frame(width: 330, height: 60, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(red:241/255, green: 231/255, blue: 159/255)))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 26)!))
                .foregroundColor(Color.black)
                .padding(.top, 20)
            
            
        }
        //}
        .frame(height: 900)
        .background(Color(red:0.436, green: 0.558, blue: 0.925))
        .padding(.bottom, 100)
        .onAppear(perform: {getDrivingTime(event: event){ time in
            print("time to location is:", time!, " seconds")
        }})
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
