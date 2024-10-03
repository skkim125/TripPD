//
//  TripPDApp.swift
//  TripPD
//
//  Created by 김상규 on 9/12/24.
//

import SwiftUI

@main
struct TripPDApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                NetworkMonitor.shared.stopMonitoring()
            case .active:
                NetworkMonitor.shared.startMonitoring()
            default:
                break
            }
        }
    }
}
