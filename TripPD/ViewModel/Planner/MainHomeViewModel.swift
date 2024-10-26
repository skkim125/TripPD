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
    
    init() {
        self.travelListForView = travelManager.travelListForView.filter({ $0.isDelete == false })
    }
    
    enum Action {
        case sortAction(SortType)
    }
    
    func action(action: Action) {
        switch action {
        case .sortAction(let sortType):
            travelListForView = travelManager.sortAction(sortType: sortType)
        }
    }

    func getRealmURL() {
        travelManager.detectRealmURL()
    }
}
