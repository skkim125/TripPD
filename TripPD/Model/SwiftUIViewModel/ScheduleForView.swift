//
//  ScheduleForView.swift
//  TripPD
//
//  Created by 김상규 on 10/2/24.
//

import Foundation

struct ScheduleForView: Identifiable {
    var id = UUID().uuidString
    var day: Date
    var dayString: String
    var places: [Place]
    var photos: [String]
    var diary: Diary?
    var finances: [Finance]
    
    init(id: String = UUID().uuidString, day: Date, dayString: String, places: [Place], photos: [String], diary: Diary?, finances: [Finance]) {
        self.id = id
        self.day = day
        self.dayString = dayString
        self.places = places
        self.photos = photos
        self.diary = diary
        self.finances = finances
    }
    
    init(schedule: Schedule) {
        self.id = schedule.id.stringValue
        self.day = schedule.day
        self.dayString = schedule.dayString
        self.places = schedule.places.map({ $0 })
        self.photos = schedule.photos.map({ $0 })
        self.diary = schedule.diarys.map({ $0 })
        self.finances = schedule.finances.map({ $0 })
    }
}
