//
//  StatsView.swift
//  DayKeeperApp
//
//  Created by Ariel Attias on 2/5/22.


import SwiftUI

struct StatsView: View {
    var body: some View {
        ZStack {
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
