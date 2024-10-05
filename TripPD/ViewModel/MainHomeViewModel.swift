//
//  MainHomeViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/4/24.
//

import Foundation
import Combine

final class MainHomeViewModel: ObservableObject {
    @Published var showToastView: Bool
    @Published var sortType: SortType = .def
    
    init(showToastView: Bool) {
        self.showToastView = showToastView
    }
    
    enum Action {
        case showToastView
        case sortAction
    }
    
    func action(action: Action) {
        switch action {
        case .showToastView:
            showToastView.toggle()
        case .sortAction:
            switch self.sortType {
            case .def:
                sortType = .closer
            case .closer:
                sortType = .def
            }
        }
    }
}
