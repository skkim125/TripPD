//
//  AddPlaceMapViewModel.swift
//  TripPD
//
//  Created by 김상규 on 10/26/24.
//

import Foundation
import Combine
import MapKit

final class AddPlaceMapViewModel: BaseViewModel {
    let kakaoLocalManager = KakaoLocalManager.shared
    let networkMonitor = NetworkMonitor.shared
    var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let schedule: CurrentValueSubject<ScheduleForView, Never>
        let seletedPlace = PassthroughSubject<PlaceInfo, Never>()
    }
    
    struct Output {
        var annotations: [CustomAnnotation] = []
        var isSelectedPlace: PlaceForView?
        var placeURL: String = ""
        var travelTime: Date = Date()
        var placeMemo = ""
    }
    
    var input: Input
    
    @Published
    var output: Output
    
    init(schedule: ScheduleForView) {
        self.input = Input(schedule: CurrentValueSubject<ScheduleForView, Never>(schedule))
        self.output = Output()
        
        transform()
    }
    
    func transform() {
        input.schedule
            .sink { [weak self] value in
                guard let self = self else { return }
                self.output.travelTime = value.day
            }
            .store(in: &cancellable)
        
        input.seletedPlace
            .sink { [weak self] place in
                guard let self = self else { return }
                let lat = Double(place.lat) ?? 0.0
                let lon = Double(place.lon) ?? 0.0
                
                self.output.placeURL = place.placeURL
                self.output.isSelectedPlace = PlaceForView(time: self.output.travelTime, name: place.placeName, address: place.roadAddress, lat: lat, lon: lon, isStar: false)
            }
            .store(in: &cancellable)
    }
    
    func action(action: Action) {
        switch action {
        case .selectPlace(let placeInfo):
            input.seletedPlace
                .send(placeInfo)
        }
    }
    
    enum Action {
        case selectPlace(PlaceInfo)
    }
}
