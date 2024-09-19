//
//  Travel.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 여행 플랜
final class Travel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var date: Date // 여행 플랜 생성 날짜
    @Persisted var title: String // 여행 타이틀
    @Persisted var travelConcept: String? // 여행 컨셉
    @Persisted var travelDate: RealmList<Date> // 여행 날짜
    @Persisted var schedules: RealmList<Schedule> // 여행 일정
    @Persisted var isStar: Bool // 별표 여부
    @Persisted var isDelete: Bool // 삭제 여부
    @Persisted var coverImageURL: String? // 커버 이미지 여부
    
    convenience init(date: Date, title: String, travelConcept: String? = nil, travelDate: RealmList<Date>, schedules: RealmList<Schedule>, isStar: Bool = false, isDelete: Bool = false, coverImageURL: String? = nil) {
        self.init()
        self.date = date
        self.title = title
        self.travelConcept = travelConcept
        self.travelDate = travelDate
        self.schedules = schedules
        self.isStar = isStar
        self.isDelete = isDelete
        self.coverImageURL = coverImageURL
    }
}
