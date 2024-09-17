//
//  Schedule.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 여행 일정
final class Schedule: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var day: Date // 날짜(n일차)
    @Persisted var places: List<Place> // 여행 타임테이블
    @Persisted var photos: List<String> // 해당 날의 사진
    @Persisted var diarys: Diary? // 해당 날의 일기
    @Persisted var finances: List<Finance> // 지출 내역 리스트
    
    convenience init(day: Date, places: List<Place>, photos: List<String>, diarys: Diary? = nil, finances: List<Finance>) {
        self.init()
        self.day = day
        self.places = places
        self.photos = photos
        self.diarys = diarys
        self.finances = finances
    }
}
