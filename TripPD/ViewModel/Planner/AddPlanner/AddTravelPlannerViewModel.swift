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
    @Published var title = ""
    @Published var travelConcept = ""
    @Published var image: Data?
    @Published var dates: [Date] = []
    @Published var showDatePickerView = false
    @Published var showPHPickeView = false
    
    var isFilled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !dates.isEmpty
    }
    
    var dateText: String {
        if let firstDay = dates.first, let lastDay = dates.last {
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
                let url = ImageManager.shared.saveImage(imageData: self.image)
                
                self.travelManager.addTravel(date: Date(), title: self.title, travelConcept: self.travelConcept, travelDate: self.dates, coverImageURL: url)
            }
        }
    }
}
// self.showSheet = false
