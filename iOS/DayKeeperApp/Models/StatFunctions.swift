//
//  StatFunctions.swift
//  DayKeeperApp
//
//  Created by Ariel Attias on 5/11/22.
//

// of all possible events in the last 5 days, find out how many you were on time for
import SwiftUI
import FLCharts
func get_total_percentage(events: [Event]) -> Int {
    
    
    var sum = 0
    var  percentage = 0.0
    let event_count = find_event_count(events: events)
    
    for event in events {
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

func worst_and_best_event(events: [Event]) -> Array<String>{
    if events.count == 0 {
        
        return ["Add events!", "Add Events!"]
        
    }
    
    
    var worst_event = " "
    var best_event = " "
    
    //sorts in descending order
    let sorted_events = events.sorted(by: {LHS, RHS in
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


func worst_and_best_time(events: [Event]) -> Dictionary<String, Int> {
    
    if getEventsFromDb().count == 0 {
        
        return ["morning": 0, "afternoon": 0, "night": 0]
        
    }
    
    var time_array = ["morning": 0, "afternoon": 0, "night": 0]
    var total_array = ["morning": 0, "afternoon": 0, "night": 0]
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH" // "a" prints "pm" or "am"
    
    for event in events {
        
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
    
    
    if total_array["morning"] != 0 {
        time_array["morning"]! = Int(round(100.0 * Double(time_array["morning"]!)/Double(total_array["morning"]!)))
    }
    if total_array["afternoon"] != 0 {
        time_array["afternoon"]! = Int(round(100.0 * Double(time_array["afternoon"]!)/Double(total_array["afternoon"]!)))
    }
    if total_array["night"] != 0 {
        time_array["night"]! = Int(round(100.0 * Double(time_array["night"]!)/Double(total_array["night"]!)))
    }
    
    
    //  print(time_array)
    return time_array
}


func find_event_count(events: [Event]) -> Int{
    var sum = 0
    for event in events {
        sum += event.Timeliness.count
    }
    
    return sum
}



func create_Chart(events: [Event]) -> FLCard {
    
    let weekdata = create_chart_data(events: events)
    
    let chartData = FLChartData(title: "Week",
                             data: weekdata,
                             legendKeys: [Key(key: "F1", color: .Gradient.purpleCyan),
                                        Key(key: "F2", color: .green),],
                            unitOfMeasure: "Events")
    
    
    let chart = FLChart(data: chartData, type: .bar())
    
    let card = FLCard(chart: chart, style: .rounded)
    card.showAverage = true
    card.showLegend = false
    
    return card
}

func create_chart_data(events: [Event]) -> [MultiPlotable] {
    //MultiPlotable(name: "jan", values: [30]),
    let weekData = [MultiPlotable(name: "Mon", values: [0,0]),
                    MultiPlotable(name: "Tue", values: [0,0]),
                    MultiPlotable(name: "Wed", values: [0,0]),
                    MultiPlotable(name: "Thu", values: [0,0]),
                    MultiPlotable(name: "Fri", values: [0,0]),]
    
    
    for event in events {
           
           let myCalendar = Calendar(identifier: .gregorian)
           let weekDay = myCalendar.component(.weekday, from: event.StartDate)
        
        // 1 is sunday, 2 is monday, 3 is tuesday, etc
        if weekDay-2 <= 4{
            var plotable = weekData[weekDay-2]
            
            if event.Timeliness.last == 1{
                plotable.values[0] += 1
                
            }
            else{
                plotable.values[1] += 1
            }
        }
    }
    
    return weekData
}
