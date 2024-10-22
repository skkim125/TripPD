//
//  PlanningScheduleViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/7/24.
//

import Foundation
import Combine
import MapKit

final class PlanningScheduleViewModel: ObservableObject {
    private let travelManager = TravelManager.shared
    var cancellable = Set<AnyCancellable>()
    
    init(schedule: ScheduleForView) {
        self.input = Input(schedule: CurrentValueSubject<ScheduleForView, Never>(schedule))
        self.output = Output(schedule: schedule)
        transform()
    }
    
    var input: Input
    
    @Published
    var output: Output
    
    struct Input {
        var schedule: CurrentValueSubject<ScheduleForView, Never>
        var deletedPlaceId = PassthroughSubject<String, Never>()
        var selectPlace = PassthroughSubject<PlaceForView, Never>()
    }
    
    struct Output {
        var schedule: ScheduleForView
        var annotations: [PlaceMapAnnotation] = []
        var seletePlace: PlaceForView?
        var deleteAction = false
        var deletePlaceID = ""
    }
    
    enum Action {
        case deletePlaceAction(String)
        case transAnotation(ScheduleForView)
        case selectPlace(PlaceForView)
    }
    
    func action(action: Action) {
        switch action {
        case .transAnotation(let schedule):
            input.schedule
                .send(schedule)
        case .deletePlaceAction(let id):
            input.deletedPlaceId
                .send(id)
        case .selectPlace(let place):
            input.selectPlace
                .send(place)
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
                    self.action(action: .transAnotation(self.output.schedule))
                }
            }
            .store(in: &cancellable)
        
        input.schedule
            .sink { [weak self] value in
                guard let self = self else { return }
                
                self.output.annotations.removeAll()
                
                for place in value.places.sorted(by: { $0.time < $1.time }) {
                    let annotation = PlaceMapAnnotation(place: place)
                    self.output.annotations.append(annotation)
                }
            }
            .store(in: &cancellable)
        
        input.selectPlace
            .sink { [weak self] value in
                guard let self = self else { return }
                self.output.seletePlace = value
            }
            .store(in: &cancellable)
    }
}
