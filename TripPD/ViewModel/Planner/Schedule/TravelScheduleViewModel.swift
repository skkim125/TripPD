//
//  TravelScheduleListViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/6/24.
//

import Foundation
import SwiftUI

final class TravelScheduleViewModel: ObservableObject {
    @Published var travel: TravelForView
    @Published var showEditView = false
    @Published var showDeleteAlert = false
    
    init(travel: TravelForView) {
        self.travel = travel
    }
    
    enum Action {
        case showDeleteAlert
        case deleteAction
    }
    
    func action(action: Action) {
        switch action {
        case .showDeleteAlert:
            showDeleteAlert.toggle()
        case .deleteAction:
            showDeleteAlert.toggle()
            TravelManager.shared.removeTravel(travel: self.travel)
        }
    }
}
