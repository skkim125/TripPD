//
//  ContentView.swift
//  TripPD
//
//  Created by 김상규 on 9/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LazyWrapperView(MainHomeView())
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            
            LazyWrapperView(TravelMapView())
                .tabItem {
                    Image(systemName: "map")
                    Text("내 주변")
                }
            
            LazyWrapperView(UserView())
                .tabItem {
                    Image(systemName: "gear")
                    Text("설정")
                }
        }
        .tint(.subColor2)
    }
}

#Preview {
    ContentView()
}
