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
    @Published var showDeleteAlert = false
    @Published var editPlace: PlaceForView?
    @Published var selectedTab = 0
    
    init(travel: TravelForView) {
        self.travel = travel
    }
    
    enum Action {
        case showDeleteAlert
        case deleteAction
        case editPlacceAction(String)
    }
    
    func action(action: Action) {
        switch action {
        case .showDeleteAlert:
            showDeleteAlert.toggle()
        case .deleteAction:
            showDeleteAlert.toggle()
            TravelManager.shared.removeTravel(travel: self.travel)
        case .editPlacceAction(let id):
            guard let place = travel.schedules[selectedTab].places.first(where: { $0.id == id }) else { return }
            editPlace = place
        }
    }
}
