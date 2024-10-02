//
//  TravelForView.swift
//  TripPD
//
//  Created by 김상규 on 10/2/24.
//

import Foundation

struct TravelForView: Identifiable {
    var id = UUID().uuidString
    var date: Date
    var title: String
    var travelConcept: String?
    var travelDate: [Date]
    var schedules: [ScheduleForView]
    var isStar: Bool
    var isDelete: Bool
    var coverImageURL: String?
    
    init(id: String = UUID().uuidString, date: Date, title: String, travelConcept: String? = nil, travelDate: [Date], schedules: [ScheduleForView], isStar: Bool, isDelete: Bool, coverImageURL: String? = nil) {
        self.id = id
        self.date = date
        self.title = title
        self.travelConcept = travelConcept
        self.travelDate = travelDate
        self.schedules = schedules
        self.isStar = isStar
        self.isDelete = isDelete
        self.coverImageURL = coverImageURL
    }
    
    init(travel: Travel) {
        self.id = travel.id.stringValue
        self.date = travel.date
        self.title = travel.title
        self.travelConcept = travel.travelConcept
        self.travelDate = Array(travel.travelDate)
        self.schedules = travel.schedules.map({ ScheduleForView(schedule: $0) })
        self.isStar = travel.isStar
        self.isDelete = travel.isDelete
        self.coverImageURL = travel.coverImageURL
    }
}
