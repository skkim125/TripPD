//
//  PastTravelViewModel.swift
//  TripPD
//
//  Created by 김상규 on 11/11/24.
//

import Foundation
import Combine

final class PastTravelViewModel: BaseViewModel {
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
                self.output.pastTravels = travels.filter({ $0.isDelete })
            }
            .store(in: &cancellable)
    }
    
    func action(action: Action) {
        
    }
}

extension PastTravelViewModel {
    struct Input {
        let trigger = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var pastTravels: [TravelForView] = []
    }
    
    enum Action {
        
    }
}
