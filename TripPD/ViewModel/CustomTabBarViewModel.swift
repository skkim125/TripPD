//
//  CustomTabBarViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/4/24.
//

import Foundation
import Combine

final class CustomTabBarViewModel: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var showSheet: Bool = false
    @Published var hideTabBar: Bool = false
    
    enum Action {
        case clickedTab(Tab)
        case showSheet
    }
    
    func action(action: Action) {
        switch action {
        case .clickedTab(let tab):
            switch tab {
            case .home:
                selectedTab = .setting
            case .setting:
                selectedTab = .home
            }
            
        case .showSheet:
            showSheet.toggle()
        }
    }
}
