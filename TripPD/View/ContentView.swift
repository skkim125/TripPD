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
                    Task {
                        try? await Task.sleep(for: .seconds(2))
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
