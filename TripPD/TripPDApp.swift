//
//  TripPDApp.swift
//  TripPD
//
//  Created by 김상규 on 9/12/24.
//

import SwiftUI

@main
struct TripPDApp: App {
    @AppStorage("AppDarkMode") private var appDarkMode: String = AppDarkMode.system.rawValue
    var currentMode: AppDarkMode {
        AppDarkMode(rawValue: appDarkMode) ?? .system
    }
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        NetworkMonitor.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(AppDarkMode(rawValue: appDarkMode)?.colorScheme)
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

enum AppDarkMode: String, CaseIterable {
    case light = "라이트 모드"
    case dark = "다크 모드"
    case system = "시스템 기본값"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        @unknown default:
            return .light
        }
    }
}
