//
//  MainHomeViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/4/24.
//

import Foundation
import Combine

final class MainHomeViewModel: BaseViewModel {
    var cancellable = Set<AnyCancellable>()
    private let travelManager = TravelManager.shared
    
    var input: Input
    
    @Published
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        travelManager.$travelListForView
            .sink { [weak self] travels in
                guard let self = self else { return }
                self.output.currentTravels = travels.filter({ !$0.isDelete })
            }
            .store(in: &cancellable)
        
        input.sortAction
            .sink { [weak self] value in
                guard let self = self else { return }
                self.output.currentTravels = travelManager.sortAction(sortType: value)
            }
            .store(in: &cancellable)
    }
    
    func action(action: Action) {
        switch action {
        case .sortAction(let sortType):
            input.sortAction
                .send(sortType)
        }
    }
}

extension MainHomeViewModel {
    struct Input {
        let sortAction = CurrentValueSubject<SortType, Never>(.def)
    }
    
    struct Output {
        var currentTravels: [TravelForView] = []
    }
    
    enum Action {
        case sortAction(SortType)
    }
}

extension MainHomeViewModel {
    func getRealmURL() {
        travelManager.detectRealmURL()
    }
}
