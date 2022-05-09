//
//  StatsView.swift
//  DayKeeperApp
//
//  Created by Ariel Attias on 2/5/22.


import SwiftUI

struct StatsView: View {
    var body: some View {
        ZStack {
            Text(String(worst_and_best_event()[0]))
            Text(String(worst_and_best_event()[1]))
            Text(String(get_total_percentage()))
            Rectangle()
                .fill(Color.gray)
                .frame(width: 150, height: 100)
                .position(x: 300, y: 100)
            
            Rectangle()
                .fill(Color.gray)
                .frame(width: 150, height: 100)
                .position(x: 300, y: 210)
            
            Rectangle()
                .fill(Color.gray)
                .frame(width: 150, height: 180)
                .position(x: 100, y: 170)
            
            Capsule()
                .fill(Color.green)
                .frame(width: 100, height: 50)
                .position(x: 70, y: 20)
            
            
            
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}


// of all possible events in the last 5 days, find out how many you were on time for
func get_total_percentage() -> Int {
    var sum = 0
    var  percentage = 0
    let event_count = getEventsFromDb().count * 5
    
    for event in getEventsFromDb(){
        
        sum += event.Timeliness.reduce(0, +)
        
    }
    
    if event_count != 0 {
        percentage = sum/event_count * 100
    }
    
    return Int(percentage)
}

func worst_and_best_event() -> Array<String>{
    
    var worst_event = " "
    var best_event = " "
    
    //sorts in descending order
    let sorted_events = getEventsFromDb().sorted(by: {LHS, RHS in
        if  LHS.OnTime == RHS.OnTime {
            return LHS.Timeliness.reduce(0, +) < LHS.Timeliness.reduce(0, +)
        }
        
        return LHS.OnTime > RHS.OnTime
    })
    
    worst_event = sorted_events[0].Title
    best_event = sorted_events[-1].Title
    
    
    return [worst_event, best_event]
}


func worst_and_best_time() -> Array<String> {
    var time_array = [0, 0, 0]

    
    
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
