//
//  AddTravelPlannerViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/5/24.
//

import Foundation
import Combine

final class AddTravelPlannerViewModel: ObservableObject {
    var travelManager = TravelManager.shared
    @Published var travel: TravelForAdd = TravelForAdd(title: "", travelConcept: "", dates: [], isStar: false)
    @Published var showDatePickerView = false
    @Published var showPHPickeView = false
    
    var isFilled: Bool {
        !travel.title.trimmingCharacters(in: .whitespaces).isEmpty && !travel.dates.isEmpty
    }
    
    var dateText: String {
        if let firstDay = travel.dates.first, let lastDay = travel.dates.last {
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
    
    init() { }
    
    enum Action {
        case showDatePickerView
        case showPHPickeView
        case addButtonAction
    }
    
    func action(action: Action) {
        switch action {
        case .showDatePickerView:
            showDatePickerView.toggle()
        case .showPHPickeView:
            showPHPickeView.toggle()
        case .addButtonAction:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let url = ImageManager.shared.saveImage(imageData: self.travel.image)
                
                self.travelManager.addTravel(date: Date(), title: self.travel.title, travelConcept: self.travel.travelConcept, travelDate: self.travel.dates, coverImageURL: url)
            }
        }
    }
}
// self.showSheet = false
