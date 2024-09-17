//
//  Travel.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 여행 플랜
final class Travel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var date: Date // 여행 플랜 생성 날짜
    @Persisted var title: String // 여행 타이틀
    @Persisted var travelConcept: String? // 여행 컨셉
    @Persisted var schedules: List<Schedule> // 여행 일정
    
    convenience init(date: Date, title: String, travelDescription: String? = nil, schedules: List<Schedule>) {
        self.init()
        self.date = date
        self.title = title
        self.travelConcept = travelDescription
        self.schedules = schedules
    }
}
