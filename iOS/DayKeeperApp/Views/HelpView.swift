//
//  HelpView.swift
//  DayKeeperApp
//
//  Created by Jonah Kalsner Kershen on 2/6/22.
//

import SwiftUI

struct HelpView: View {
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(Color(red:0.436, green: 0.558, blue: 0.925)) // Uses UIColor
      
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Help")
                    .frame(width: 200, alignment: .leading) // setting width and line limit can force wrapping
                    .lineLimit(2)
                    .shadow(radius: 15)
                    .foregroundColor(Color.textColor)
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 45)!))
                    .padding(.vertical, 5.0)
                    .background(RoundedRectangle(cornerRadius: 60).fill(Color(red:0.436, green: 0.558, blue: 0.925 )))
                    .minimumScaleFactor(0.5)
                                .lineLimit(1)

                
            }
            //.padding(.top, 10)
            //.frame(width: 500, height: 80, alignment: .center)
      //      .background(Color(red:0.436, green: 0.558, blue: 0.925))
            VStack(alignment: .leading, spacing: 0 ) {
                Text("Why do I need this app?")
                               Text("This is is the first calendar to learn your habits! We'll not only let you know when your events are, we'll get you there on time too!")
                                   .foregroundColor(Color(red:1.0, green: 0.941, blue: 0.612))
                Text("How does the calendar learn ?")
                               Text("Whenever you get to an event, we'll ask you if you were on time or not. Your response teaches us what to do!")
                                   .foregroundColor(Color(red:1.0, green: 0.941, blue: 0.612))
                Text("Where can I add events?")
                               Text("You can add new events with the 'Create Event' button on the Events tab.")
                                   .foregroundColor(Color(red:1.0, green: 0.941, blue: 0.612))
              
                }
            }
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
           .padding(.top, 0)
    }
  
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
