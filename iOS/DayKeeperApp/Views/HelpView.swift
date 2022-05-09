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
                Text("How Can We Help?")
                    .padding(.top, 50)
                    .padding(.bottom, 75)
                    .shadow(radius: 15)
                    .foregroundColor(Color("Off-White"))
                    .font(Font(uiFont: UIFont(name: "Lemon-Regular", size: 30)!))
                    .background(Color(red:0.436, green: 0.558, blue: 0.925 ))
                    .minimumScaleFactor(0.5)
                    
                
                Text("Commonly Asked Questions")
                    .font(.system(size: 25))
                    .padding(.bottom, 50)
                
                
                Form {
                    DisclosureGroup("What Does DayKeeper Do?"){
                        Text("DayKeeper is an AI Enabled Notification System, that learns your schedule and helps you stay on top of your day. Through our intelligent AI, we manage notifications for your upcoming events and help you figure out what is necessary to be ready for your day.")
                    }
                    DisclosureGroup("How Does DayKeeper Learn?"){
                        Text("DayKeepers notifications ask a simple question: Were you on time? With this data we are able to schedule notifications for you in a manner that allows you to be more ready for your day as you go. Based off previous events, our own studies, and your schedule we are able to tailor make suggestions for when you should start getting ready and what you should do to get ready. Allowing you to conqour your day.")
                    }
                    DisclosureGroup("Where Can I Add Calendar Events?"){
                        Text("On the Event's Tab in the Top Right Corner, there is a Create Event Button. Click this and add in to your calendar from the app. You can also add your events to your calendar, which we periodically scan to make sure we are up to date with your schedule.")
                    }
                    DisclosureGroup("How Can I Change The Notification Settings?"){
                        Text("By switching to the settings tab, you can see what notifications can be controlled and toggle them as you see fit.")
                    }
                    DisclosureGroup("How Does DayKeeper Read My Calendar?"){
                        Text("When you create an account for DayKeeper, we ask permission to read your apple calendar. By giving us this permission, we are able to see what tasks you have for the day.")
                    }
                    DisclosureGroup("Does DayKeeper Track My Progress?"){
                        Text("Yes we do! By switching to the Stats tab, you can see how on time you have been, what events you miss most often, and your progress since using DayKeeper!")
                    }
                    DisclosureGroup("What Does DayKeeper do with my data?"){
                        Text("Absolutley nothing. Your Data is unique to you and our AI only is allowed to use your data when helping you. Otherwise it is encrypted and locked away so noone, not even the developers, can see your data.")
                    }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red:0.436, green: 0.558, blue: 0.925))
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
