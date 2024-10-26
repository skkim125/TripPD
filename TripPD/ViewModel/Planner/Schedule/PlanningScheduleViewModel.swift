//
//  PlanningScheduleViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/7/24.
//

import SwiftUI
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
        var editPlaceId = PassthroughSubject<String, Never>()
        var selectPlace = PassthroughSubject<PlaceForView, Never>()
    }
    
    struct Output {
        var schedule: ScheduleForView
        var annotations: [PlaceMapAnnotation] = []
        var seletePlace: PlaceForView?
        var deleteAction = false
        var deletePlaceID = ""
        var editPlace: PlaceForView?
        var routeCoordinates: [CLLocationCoordinate2D] = []
    }
    
    enum Action {
        case deletePlaceAction(String)
        case editPlaceAction(String)
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
            
        case .editPlaceAction(let id):
            input.editPlaceId
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
                    self.action(action: .transAnotation(self.input.schedule.value))
                }
            }
            .store(in: &cancellable)
        
        input.editPlaceId
            .sink { [weak self] value in
                guard let self = self else { return }
                guard let editPlace = self.output.schedule.places.first(where: { $0.id == value }) else { return }
                self.output.editPlace = editPlace
            }
            .store(in: &cancellable)
        
        input.schedule
            .sink { [weak self] value in
                guard let self = self else { return }
                
                self.output.annotations = value.places.sorted(by: { $0.time < $1.time }).map { PlaceMapAnnotation(place: $0) }
                self.output.routeCoordinates = value.places.sorted(by: { $0.time < $1.time }).map({ CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) })
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
