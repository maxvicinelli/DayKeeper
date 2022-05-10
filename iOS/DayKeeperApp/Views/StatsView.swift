//
//  StatsView.swift
//  DayKeeperApp
//
//  Created by Ariel Attias on 2/5/22.


import SwiftUI

struct StatsView: View {
    
    @ObservedObject var viewModel : ShuffleViewModel = ShuffleViewModel()
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color(red:0.436, green: 0.558, blue: 0.925)) // Uses UIColor
      
    }
    
  
    
    var body: some View {
        ZStack {
            Text("Statistics")
                .position(x: 200, y: 10)
                .padding(.top, 50)
                .padding(.bottom, 75)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 30)!))
                .minimumScaleFactor(0.5)
            
            Text(String(worst_and_best_event()[0])).position(x: 300, y: 100)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            
            Text("Best Event").position(x: 300, y: 120)
            .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 10)!))
            
            Text(String(worst_and_best_event()[1])).position(x: 300, y: 210)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 20)!))
            
            Text("Worst Event").position(x: 300, y: 230)
            .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 10)!))
            
            Text(String(get_total_percentage()) + "%").position(x: 100, y: 150)
                .shadow(radius: 15)
                .foregroundColor(Color("Off-White"))
                .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 80)!))
                .minimumScaleFactor(0.5)
            
            Text("On Time").position(x: 100, y: 200)
    
            
    
            
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
          
        
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}


// of all possible events in the last 5 days, find out how many you were on time for
func get_total_percentage() -> Int {
    print("get_total_percentage")
    var sum = 0
    var  percentage = 0.0
    let event_count = find_event_count()
    
    for event in getEventsFromDb(){
        sum += event.Timeliness.reduce(0, +)
        
    }
    print("event_count")
    print(event_count)
    
    print("SUM")
    print(sum)
    
    if event_count != 0 {
        print("TEST event count")
        print(53.0/103.0)
        percentage = Double(sum)/Double(event_count) * 100.0
        print("Percentage")
        
        print(round(percentage))
        
    }


    return Int(round(percentage))
}

func worst_and_best_event() -> Array<String>{
    if getEventsFromDb().count == 0 {
        
        return ["Add events!", "Add Events!"]
        
    }
    
    
    
    
    var worst_event = " "
    var best_event = " "
    
    //sorts in descending order
    let sorted_events = getEventsFromDb().sorted(by: {LHS, RHS in
        if  LHS.OnTime == RHS.OnTime {
            return LHS.Timeliness.reduce(0, +) < LHS.Timeliness.reduce(0, +)
        }
        
        return LHS.OnTime > RHS.OnTime
    })
    
    worst_event = sorted_events.first!.Title
    best_event = sorted_events.last!.Title
    
    
    return [worst_event, best_event]
}


func worst_and_best_time() -> Array<String> {
    var time_array = [0, 0, 0]
    if getEventsFromDb().count == 0 {
        
        return ["Add events!", "Add Events!", "Add Events!"]
        
    }
    
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH" // "a" prints "pm" or "am"
    
    for event in getEventsFromDb(){
        var hour = Int(formatter.string(from: event.StartDate))
            
        if hour! >= 4 && hour! <= 11 {
            time_array[0] += event.Timeliness.reduce(0, +)
        }
            
        if hour! >= 12 && hour! <= 19 {
            time_array[1]  += event.Timeliness.reduce(0, +)
                
        }
    
        if hour! >= 19 || hour! <= 4 {
            time_array[2]  += event.Timeliness.reduce(0, +)
        }
            
        }
        
    
    return [" "]
    }


func find_event_count() -> Int{
    var sum = 0
    for event in getEventsFromDb(){
        sum += event.Timeliness.count
        
    }
    
    return sum
}

class ShuffleViewModel : ObservableObject {
    @Published var listData = ["one", "two", "three", "four"]

    func shuffle() {
        listData.shuffle()
        //or listData = dictionary.shuffled().prefix(upTo: 10)
    }
}
