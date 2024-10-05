//
//  ContentView.swift
//  TripPD
//
//  Created by 김상규 on 9/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLaunch = false
    
    var body: some View {
        if !isLaunch {
            LaunchScreen()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isLaunch = true
                        }
                    }
                }
        } else {
            CustomTabBar()
        }
    }
}

#Preview {
    ContentView()
}
