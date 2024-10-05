//
//  MainHomeViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/4/24.
//

import Foundation
import Combine

final class MainHomeViewModel: ObservableObject {
    private let travelManager = TravelManager.shared
    @Published var travelListForView: [TravelForView] = []
    @Published var showToastView: Bool
    
    init(showToastView: Bool) {
        self.travelListForView = travelManager.travelListForView
        self.showToastView = showToastView
    }
    
    enum Action {
        case showToastView
        case sortAction(SortType)
    }
    
    func action(action: Action) {
        switch action {
        case .showToastView:
            showToastView.toggle()
        case .sortAction(let sortType):
            travelListForView = travelManager.sortAction(sortType: sortType)
        }
    }

    func getRealmURL() {
        travelManager.detectRealmURL()
    }
}
