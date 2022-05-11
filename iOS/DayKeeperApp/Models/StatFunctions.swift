//
//  StatFunctions.swift
//  DayKeeperApp
//
//  Created by Ariel Attias on 5/11/22.
//

// of all possible events in the last 5 days, find out how many you were on time for
func get_total_percentage() -> Int {
    
    
    var sum = 0
    var  percentage = 0.0
    let event_count = find_event_count()
    
    for event in getEventsFromDb(){
        sum += event.Timeliness.reduce(0, +)
        
    }
    //    print("event_count")
    // print(event_count)
    
    //  print("SUM")
    //  print(sum)
    
    if event_count != 0 {
        //   print("TEST event count")
        //  print(53.0/103.0)
        percentage = Double(sum)/Double(event_count) * 100.0
        //  print("Percentage")
        
        // print(round(percentage))
        
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
    // print("PRINT SORTED EVENTS")
    //   print(sorted_events)
    worst_event = sorted_events.last!.Title
    best_event = sorted_events.first!.Title
    
    
    
    return [worst_event, best_event]
}


func worst_and_best_time() -> Dictionary<String, Int> {
    
    if getEventsFromDb().count == 0 {
        
        return ["morning": 0, "afternoon": 0, "night": 0]
        
    }
    
    var time_array = ["morning": 0, "afternoon": 0, "night": 0]
    var total_array = ["morning": 0, "afternoon": 0, "night": 0]
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH" // "a" prints "pm" or "am"
    
    for event in getEventsFromDb(){
        
        var hour = Int(formatter.string(from: event.StartDate))
        
        if hour! >= 4 && hour! <= 11 {
            time_array["morning"]! += event.Timeliness.reduce(0, +)
            total_array["morning"]! += event.Timeliness.count
        }
        
        if hour! >= 12 && hour! <= 19 {
            time_array["afternoon"]!  += event.Timeliness.reduce(0, +)
            total_array["afternoon"]! += event.Timeliness.count
        }
        
        if hour! >= 19 || hour! <= 4 {
            time_array["night"]! += event.Timeliness.reduce(0, +)
            total_array["night"]! += event.Timeliness.count
        }
    }
    
    time_array["morning"]! = Int(round(100.0 * Double(time_array["morning"]!)/Double(total_array["morning"]!)))
    time_array["afternoon"]! = Int(round(100.0 * Double(time_array["afternoon"]!)/Double(total_array["afternoon"]!)))
    time_array["night"]! = Int(round(100.0 * Double(time_array["night"]!)/Double(total_array["night"]!)))
    
    //  print(time_array)
    return time_array
}


func find_event_count() -> Int{
    var sum = 0
    for event in getEventsFromDb(){
        sum += event.Timeliness.count
    }
    
    return sum
}
