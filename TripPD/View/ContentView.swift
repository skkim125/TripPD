//
//  ContentView.swift
//  TripPD
//
//  Created by 김상규 on 9/12/24.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    var travelManager = TravelManager.shared
    
    var body: some View {
        CustomTabBar(travelManager)
    }
}

#Preview {
    ContentView()
}
