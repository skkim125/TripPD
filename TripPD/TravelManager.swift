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
        travelListForView = Array(travelList)
    }
    
    @ObservedResults(Travel.self) var travelList
    
    @Published var travelListForView: [Travel] = []
    
    func convertArray() -> [Travel]{
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
            let schedule = Schedule(day: date, places: List<Place>(), photos: List<String>(), finances: List<Finance>())
            schedules.append(schedule)
        }
        
        let travel = Travel(date: date, title: title, travelConcept: travelConcept, travelDate: listDate, schedules: schedules, coverImageURL: coverImageURL)
        dump(travel)
        $travelList.append(travel)
        travelListForView = convertArray()
    }
}
