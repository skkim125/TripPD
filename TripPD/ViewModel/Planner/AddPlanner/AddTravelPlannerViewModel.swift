//
//  AddTravelPlannerViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/5/24.
//

import Foundation
import Combine

final class AddTravelPlannerViewModel: BaseViewModel {
    var cancellable = Set<AnyCancellable>()
    var travelManager = TravelManager.shared
    
    var input: Input
    
    @Published
    var output: Output
    
    func transform() {
        input.showDatePickerView
            .sink { [weak self] value in
                guard let self = self else { return }
                output.showDatePickerView = value
            }
            .store(in: &cancellable)
        
        input.showPHPickerView
            .sink { [weak self] value in
                guard let self = self else { return }
                output.showPHPickeView = value
            }
            .store(in: &cancellable)
        
        input.travel
            .sink { [weak self](date, travel, url) in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    self.travelManager.addTravel(date: date, title: travel.title, travelConcept: travel.travelConcept, travelDate: travel.dates, coverImageURL: url)
                }
            }
            .store(in: &cancellable)
    }
    
    init() { 
        input = Input()
        output = Output()
        
        transform()
    }
    
    func action(action: Action) {
        switch action {
        case .showDatePickerView:
            input.showDatePickerView
                .send(!output.showDatePickerView)
        case .showPHPickeView:
            input.showPHPickerView
                .send(!output.showDatePickerView)
        case .addButtonAction:
            let url = ImageManager.shared.saveImage(imageData: self.output.travel.image)
            let travel = (Date(), output.travel, url)
            
            input.travel
                .send(travel)
        }
    }
}

extension AddTravelPlannerViewModel {
    var isFilled: Bool {
        !output.travel.title.trimmingCharacters(in: .whitespaces).isEmpty && !output.travel.dates.isEmpty
    }
    
    var dateText: String {
        if let firstDay = output.travel.dates.first, let lastDay = output.travel.dates.last {
            let first = firstDay.customDateFormatter(.coverView)
            let last = lastDay.customDateFormatter(.coverView)
            
            if first == last {
                return "\(first)"
            } else {
                return "\(first) ~ \(last)"
            }
        } else {
            return ""
        }
    }
}

extension AddTravelPlannerViewModel {
    struct Input {
        let showDatePickerView = PassthroughSubject<Bool, Never>()
        let showPHPickerView = PassthroughSubject<Bool, Never>()
        let travel = PassthroughSubject<(Date, TravelForAdd, String?) , Never>()
    }
    
    struct Output {
        var showDatePickerView = false
        var showPHPickeView = false
        var travel: TravelForAdd = TravelForAdd(title: "", travelConcept: "", dates: [], isStar: false)
    }
    
    enum Action {
        case showDatePickerView
        case showPHPickeView
        case addButtonAction
    }
}

