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
    private init() {
        travelListForView = convertArray()
    }
    
    @ObservedResults(Travel.self) var travelList
    
    @Published var travelListForView: [Travel] = []
    
    func convertArray() -> [Travel] {
        return Array(travelList)
    }
    
    func detectRealmURL() {
        debugPrint(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func addTravelPlanner(date: Date, title: String, travelConcept: String, travelDate: [Date], coverImageURL: String? = nil) {
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
        travelListForView = convertArray()
    }
    
    func addPlace(schedule: Schedule, time: Date, name: String, placeMemo: String? = nil, lat: Double, lon: Double, isStar: Bool = false) {
        
        let place = Place(time: time, name: name, lat: lat, lon: lon)
        
        do {
            let realm = try Realm()
            guard let object = realm.object(ofType: Schedule.self, forPrimaryKey: schedule.id) else { return }
            try realm.write {
                object.places.append(place)
            }
        } catch {
            
        }
    }
    
//    func addTravelPlanner(date: Date, title: String, travelConcept: String, travelDate: [Date], coverImageURL: String? = nil) {
//        let listDate = RealmList<Date>()
//        listDate.append(objectsIn: travelDate)
//        
//        let schedules = RealmList<Schedule>()
//        
//        for date in travelDate {
//            let dayString = date.customDateFormatter(.dayString)
//            let schedule = Schedule(day: date, dayString: dayString, places: List<Place>(), photos: List<String>(), finances: List<Finance>())
//            schedules.append(schedule)
//        }
//        
//        let travel = Travel(date: date, title: title, travelConcept: travelConcept, travelDate: listDate, schedules: schedules, coverImageURL: coverImageURL)
//        dump(travel)
//        $travelList.append(travel)
//        travelListForView = convertArray()
//    }
}
