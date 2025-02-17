//
//  TravelScheduleListViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/6/24.
//

import Foundation
import Combine
import MapKit

final class TravelScheduleViewModel: BaseViewModel {
    private var travelManager = TravelManager.shared
    var cancellable = Set<AnyCancellable>()
    
    var input: Input
    
    @Published
    var output: Output
    
    func transform() {
        input.travel
            .sink { [weak self] travel in
                guard let self = self else { return }
                self.output.travel = travel
                self.output.travelTitle = travel.title
                self.output.schedules = travel.schedules
                
                if let currentScheduleIndex = travel.schedules.firstIndex(where: { $0.id == self.output.schedule.id }) {
                    self.updateSchedule(at: currentScheduleIndex)
                }
            }
            .store(in: &cancellable)
        
        input.selectedTab
            .sink { [weak self] tab in
                guard let self = self else { return }
                self.updateSchedule(at: tab)
                self.output.setRegion = true
            }
            .store(in: &cancellable)
        
        input.editingPlace
            .sink { [weak self] place in
                guard let self = self else { return }
                self.output.editingPlace = place
                self.output.placeMemo = place.placeMemo
                self.output.travelTime = place.time
            }
            .store(in: &cancellable)
        
        input.deletePlace
            .sink { [weak self] id in
                guard let self = self else { return }
                output.deletePlaceId = id
                self.travelManager.removePlace(placeID: id)
                self.output.setRegion = true
            }
            .store(in: &cancellable)
        
        input.deleteTravel
            .sink { [weak self] travel in
                guard let self = self else { return }
                self.travelManager.removeTravel(travel: travel)
            }
            .store(in: &cancellable)
        
        input.goPlaceOnMap
            .sink { [weak self] place in
                guard let self = self else { return }
                self.output.goPlaceOnMap = place
                
                if place == nil {
                    self.output.setRegion = true
                }
            }
            .store(in: &cancellable)
        
        travelManager.$travelListForView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] travels in
                guard let self = self,
                      let currentTravel = travels.first(where: { $0.id == self.output.travel.id })
                else { return }
                
                self.output.travel = currentTravel
                self.output.schedules = currentTravel.schedules
                
                if let currentScheduleIndex = currentTravel.schedules.firstIndex(where: { $0.id == self.output.schedule.id }) {
                    self.updateSchedule(at: currentScheduleIndex)
                }
            }
            .store(in: &cancellable)
        
        Publishers.CombineLatest(
            travelManager.$travelListForView,
            travelManager.objectWillChange
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] travels, _ in
            guard let self = self else { return }
            if let currentTravel = travels.first(where: { $0.id == self.output.travel.id }) {
                self.output.travel = currentTravel
                self.output.schedules = currentTravel.schedules
                
                if let currentScheduleIndex = currentTravel.schedules.firstIndex(where: { $0.id == self.output.schedule.id }) {
                    self.updateSchedule(at: currentScheduleIndex)
                }
            }
        })
        .store(in: &cancellable)
    }
    
    init(travel: TravelForView) {
        input = Input(travel: CurrentValueSubject<TravelForView, Never>(travel))
        output = Output()
        
        transform()
    }
    
    func action(action: Action) {
        switch action {
        case .loadView(let travel):
            input.travel
                .send(travel)
        case .changeTab(let tab):
            input.selectedTab
                .send(tab)
        case .editingPlace(let place):
            input.editingPlace
                .send(place)
        case .deletePlace(let id):
            input.deletePlace
                .send(id)
        case .deleteTravel(let travel):
            input.deleteTravel
                .send(travel)
        case .goPlaceOnMap(let place):
            input.goPlaceOnMap
                .send(place)
        case .resetPlaceRegion:
            input.goPlaceOnMap
                .send(nil)
        }
    }
}

extension TravelScheduleViewModel {
    struct Input {
        var travel: CurrentValueSubject<TravelForView, Never>
        var selectedTab = PassthroughSubject<Int, Never>()
        var editingPlace = PassthroughSubject<PlaceForView, Never>()
        var deletePlace = PassthroughSubject<String, Never>()
        var deleteTravel = PassthroughSubject<TravelForView, Never>()
        var goPlaceOnMap = PassthroughSubject<PlaceForView?, Never>()
    }
    
    struct Output {
        var travel = TravelForView(id: "", date: Date(), title: "", travelConcept: "", travelDate: [], schedules: [], isStar: false, isDelete: false, coverImageURL: "")
        var travelTitle = ""
        var schedules: [ScheduleForView] = []
        var schedule = ScheduleForView(id: "", day: Date(), dayString: "", places: [], photos: [], diary: nil, finances: [])
        var places: [PlaceForView] = []
        var annotations: [PlaceMapAnnotation] = []
        var editingPlace = PlaceForView(id: "", time: Date(), name: "", address: "", placeMemo: "", lat: 0.0, lon: 0.0, isStar: false)
        var travelTime = Date()
        var placeMemo: String?
        var deletePlaceId = ""
        var goPlaceOnMap: PlaceForView?
        var routeCoordinates: [CLLocationCoordinate2D] = []
        var setRegion: Bool = false
    }
    
    enum Action {
        case loadView(TravelForView)
        case changeTab(Int)
        case editingPlace(PlaceForView)
        case deletePlace(String)
        case deleteTravel(TravelForView)
        case goPlaceOnMap(PlaceForView?)
        case resetPlaceRegion
    }
}

extension TravelScheduleViewModel {
    private func updateSchedule(at index: Int) {
        guard index < output.schedules.count else { return }
        output.schedule = output.schedules[index]
        output.places = output.schedule.places
        output.annotations = output.places.map({ PlaceMapAnnotation(place: $0) })
        output.routeCoordinates = output.places.sorted(by: { $0.time < $1.time })
            .map({ CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) })
    }
}
