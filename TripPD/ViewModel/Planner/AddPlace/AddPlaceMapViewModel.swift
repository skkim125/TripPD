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
    private let kakaoLocalManager = KakaoLocalManager.shared
    let networkMonitor = NetworkMonitor.shared
    var cancellable = Set<AnyCancellable>()
    
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
                self.output.schedule = value
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
        
        input.search
            .flatMap { [weak self] _ -> AnyPublisher<SearchPlaceResponseModel, NetworkError> in
                guard let self = self else {
                    return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
                }
                
                // 네트워크 연결 상태 체크 추가
                if !self.networkMonitor.isConnected {
                    return Fail(error: NetworkError.invalidServerConnect).eraseToAnyPublisher()
                }
                
                return Future { promise in
                    Task {
                        do {
                            let result = try await self.kakaoLocalManager.searchPlace(
                                sort: .accuracy,
                                self.input.query,
                                page: 1
                            )
                            promise(.success(result))
                        } catch let error as NetworkError {
                            print(error)
                            promise(.failure(error))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    
                    switch completion {
                    case .failure(let error):
                        self.output.showErrorAlert = true
                        self.output.showErrorAlertTitle = error.errorDescription
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    
                    self.output.showNoResult = result.meta.total == 0
                    self.output.annotations.removeAll(keepingCapacity: true)
                    
                    result.documents.forEach { value in
                        let annotation = CustomAnnotation(placeInfo: value)
                        self.output.annotations.append(annotation)
                    }
                }
            )
            .store(in: &cancellable)
    }
    
    func action(action: Action) {
        switch action {
        case .selectPlace(let placeInfo):
            input.seletedPlace
                .send(placeInfo)
        case .search:
            input.search
                .send(())
        }
    }
}

extension AddPlaceMapViewModel {
    struct Input {
        let schedule: CurrentValueSubject<ScheduleForView, Never>
        let seletedPlace = PassthroughSubject<PlaceInfo, Never>()
        let search = PassthroughSubject<Void, Never>()
        var query = ""
    }
    
    struct Output {
        var annotations: [CustomAnnotation] = []
        var schedule = ScheduleForView(id: "", day: Date(), dayString: "", places: [], photos: [], diary: nil, finances: [])
        var isSelectedPlace: PlaceForView = PlaceForView(id: "", time: Date(), name: "", address: "", placeMemo: "", lat: 0.0, lon: 0.0, isStar: false)
        var placeURL: String = ""
        var travelTime: Date = Date()
        var placeMemo: String?
        var showNoResult: Bool = false
        var showErrorAlert: Bool = false
        var showErrorAlertTitle: String = ""
    }
}

extension AddPlaceMapViewModel {
    enum Action {
        case selectPlace(PlaceInfo)
        case search
    }
}
