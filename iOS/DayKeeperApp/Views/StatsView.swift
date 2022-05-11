//
//  StatsView.swift
//  DayKeeperApp
//
//  Created by Ariel Attias on 2/5/22.

import SwiftUI

class StatViewModel : ObservableObject {
    @Published var name: String = ""
    @State private var currentTime: Date = Date()
    var events : [Event] = getEventsFromDb()
    
    init() {
        events = getEventsFromDb()
    }
    func reload() {
        events = getEventsFromDb()
        currentTime = Date()

}
}

struct StatsView: View {
    @ObservedObject var eventClass = StatViewModel()
   
    @State var events : [Event] = getEventsFromDb()
    
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color(red:0.436, green: 0.558, blue: 0.925)) // Uses UIColor
        

    }
    
    var body: some View {
        
        
        ZStack {
            Group{
            Text("Statistics")
                .position(x: 200, y: 10)
                .padding(.top, 50)
                .padding(.bottom, 75)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 30)!))
                .minimumScaleFactor(0.5)
            
            Text(String(worst_and_best_event()[0])).position(x: 300, y: 120)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            
            Text("Best Event").position(x: 300, y: 140)
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 10)!))
            
            Text(String(worst_and_best_event()[1])).position(x: 300, y: 180)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            
            Text("Worst Event").position(x: 300, y: 200)
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 10)!))
            
            Text(String(get_total_percentage()) + "%").position(x: 100, y: 150)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 80)!))
                .minimumScaleFactor(0.5)
            
            Text("On Time").position(x: 100, y: 200)
                .shadow(radius: 15)
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            }
            
            Group {
                
                let height = 250
                let size = 30
                let time_height = height + 30
                
                Text("Morning").position(x: 100, y: CGFloat(time_height)).font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 10)!))
                Text(String(worst_and_best_time()["morning"] ?? 0) + "%").position(x: 100, y: CGFloat(height))
                    .shadow(radius: 15)
                    .foregroundColor(Color("Off-White"))
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: CGFloat(size))!))
                
                Text("Afternoon").position(x: 200, y: CGFloat(time_height)).font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 10)!))
                Text(String(worst_and_best_time()["afternoon"] ?? 0) + "%").position(x: 200, y: CGFloat(height))
                    .shadow(radius: 15)
                    .foregroundColor(Color("Off-White"))
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: CGFloat(size))!))
                
                Text("Night").position(x: 300, y: CGFloat(time_height)).font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 10)!))
                Text(String(worst_and_best_time()["night"] ?? 0) + "%").position(x: 300, y: CGFloat(height))
                    .shadow(radius: 15)
                    .foregroundColor(Color("Off-White"))
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: CGFloat(size))!))
            }
           
            
            
            
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
            .refreshable {
                eventClass.reload()
            }
       
    
    }
}



struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    
    }
}
