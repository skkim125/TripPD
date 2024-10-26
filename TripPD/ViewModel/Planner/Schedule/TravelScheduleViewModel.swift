//
//  TravelScheduleListViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/6/24.
//

import Foundation
import Combine

final class TravelScheduleViewModel: ObservableObject {
    var cancellable = Set<AnyCancellable>()
    var input: Input
    
    @Published
    var output: Output
    
    struct Input {
        var travel = PassthroughSubject<TravelForView, Never>()
        var selectedTab = PassthroughSubject<Int, Never>()
        var deleteAction = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var travel: TravelForView?
        var selectedTab: Int = 0
        var schedule: ScheduleForView?
    }
    
    init(travel: TravelForView) {
        self.input = Input()
        self.output = Output()
        
        transform()
        
        guard let index = travel.schedules.firstIndex(where: { $0.day.customDateFormatter(.dayString) == Date().customDateFormatter(.dayString) }) else {
            action(action: .trigger(travel, 0))
            
            return
        }
        
        action(action: .trigger(travel, index))
    }
    
    func transform() {
        input.travel
            .sink { [weak self] value in
                guard let self = self else { return }
                self.output.travel = value
            }
            .store(in: &cancellable)
        
        input.selectedTab
            .sink { [weak self] value in
                guard let self = self else { return }
                self.output.selectedTab = value
                self.output.schedule = output.travel?.schedules[value]
            }
            .store(in: &cancellable)
        
        input.deleteAction
            .sink { [weak self] _ in
                guard let self = self, let travel = output.travel else { return }
                TravelManager.shared.removeTravel(travel: travel)
            }
            .store(in: &cancellable)
    }
    
    enum Action {
        case trigger(TravelForView, Int)
        case changeTab(Int)
        case deleteAction
    }
    
    func action(action: Action) {
        switch action {
        case .trigger(let travel, let tab):
            input.travel
                .send(travel)
            input.selectedTab
                .send(tab)
        case .deleteAction:
            input.deleteAction
                .send(())
        case .changeTab(let tab):
            input.selectedTab
                .send(tab)
        }
    }
}
