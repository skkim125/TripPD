//
//  TravelManager.swift
//  TripPD
//
//  Created by 김상규 on 9/18/24.
//

import Foundation
import RealmSwift

final class TravelManager: ObservableObject {
    static let shared = TravelManager()
    @ObservedResults(Travel.self) var travelList
    @Published var travelListForView: [TravelForView] = []
    
    private var token: NotificationToken?
    
    private init() {
        setupObserver()
    }
    
    deinit {
        token?.invalidate()
    }
    
    private func setupObserver() {
        do {
            let realm = try Realm()
            let results = realm.objects(Travel.self)
            
            token = results.observe({ [weak self] changes in
                guard let self = self else { return }
                self.travelListForView = results.map(TravelForView.init)
            })
        } catch let error {
            print("옵저버 셋팅 실패")
            print(error.localizedDescription)
        }
    }
    
    func detectRealmURL() {
        debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func addTravel(date: Date, title: String, travelConcept: String, travelDate: [Date], coverImageURL: String? = nil) {
        
        let listDate = RealmList<Date>()
        listDate.append(objectsIn: travelDate)
        
        let schedules = RealmList<Schedule>()
        
        for date in travelDate {
            let dayString = date.customDateFormatter(.dayString)
            let schedule = Schedule(day: date, dayString: dayString, places: List<Place>(), photos: List<String>(), finances: List<Finance>())
            schedules.append(schedule)
        }
        
        let travel = Travel(date: date, title: title, travelConcept: travelConcept, travelDate: listDate, schedules: schedules, coverImageURL: coverImageURL)
        dump(travel)
        $travelList.append(travel)
    }
    
    func addPlace(schedule: ScheduleForView, time: Date, name: String, address: String, placeMemo: String? = nil, lat: Double, lon: Double, isStar: Bool = false) {
        
        let place = Place(time: time, name: name, address: address, lat: lat, lon: lon)
        
        do {
            let realm = try Realm()
            guard let object = realm.object(ofType: Schedule.self, forPrimaryKey: schedule.id) else { return }
            try realm.write {
                object.places.append(place)
            }
        } catch {
            
        }
    }
    
    func removeTravel(travel: TravelForView) {
        do {
            let realm = try Realm()
            let id = try ObjectId(string: travel.id)
            guard let object = realm.object(ofType: Travel.self, forPrimaryKey: id) else { return }
            try realm.write {
                object.schedules.forEach { schedule in
                    realm.delete(schedule.places)
                    realm.delete(schedule)
                }
                ImageManager.shared.removeImage(imageName: travel.coverImageURL)
                realm.delete(object)
            }
        } catch {
            print("travel 데이터 삭제 실패")
        }
    }
    
    func removePlace(place: PlaceForView) {
        
        do {
            let realm = try Realm()
            guard let object = realm.object(ofType: Place.self, forPrimaryKey: place.id) else { return }
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("place 데이터 삭제 실패")
        }
    }
    
    func sortAction(sortType: SortType) {
        do {
            let realm = try Realm()
            let results = realm.objects(Travel.self)
            
            token = results.observe({ [weak self] changes in
                guard let self = self else { return }
                switch sortType {
                case .def:
                    self.travelListForView = results.map(TravelForView.init).sorted(by: { $0.date < $1.date })
                case .closer:
                    self.travelListForView = results.map(TravelForView.init).sorted(by: {
                        if $0.travelDate.first ?? Date() == $1.travelDate.first ?? Date() {
                            $0.date < $1.date
                        } else {
                            $0.travelDate.first?.timeIntervalSinceNow ?? 0.0 < $1.travelDate.first?.timeIntervalSinceNow ?? 0.0
                        }
                    })
                    
                }
            })
        } catch {
            print(error)
        }
    }
}
