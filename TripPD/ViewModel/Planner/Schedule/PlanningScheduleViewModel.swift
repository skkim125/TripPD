//
//  PlanningScheduleViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/7/24.
//

import Foundation
import Combine

final class PlanningScheduleViewModel: ObservableObject {
    private let travelManager = TravelManager.shared
    var cancellable = Set<AnyCancellable>()
    
    init(schedule: ScheduleForView) {
        self.input = Input(schedule: schedule)
        self.output = Output(schedule: schedule)
        transform()
    }
    
    var input: Input
    
    @Published
    var output: Output
    
    struct Input {
        var schedule: ScheduleForView
        var deletedPlaceId = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var schedule: ScheduleForView
        var deleteAction = false
        var deletePlaceID = ""
    }
    
    enum Action {
        case deletePlaceAction(String)
    }
    
    func action(action: Action) {
        switch action {
        case .deletePlaceAction(let id):
            input.deletedPlaceId
                .send(id)
        }
    }
    
    func transform() {
        input.deletedPlaceId
            .sink { [weak self] value in
                guard let self = self else { return }
                self.output.deleteAction = true
                self.output.deletePlaceID = value
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.travelManager.removePlace(placeID: value)
                }
            }
            .store(in: &cancellable)
    }
}
