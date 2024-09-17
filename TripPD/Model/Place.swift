//
//  Place.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 장소
final class Place: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var time: Date // 시간
    @Persisted var name: String // 장소 이름
    @Persisted var placeMemo: String? // 장소 메모
    @Persisted var lat: Double // 위도
    @Persisted var lon: Double // 경도
    
    convenience init(time: Date, name: String, placeMemo: String? = nil, lat: Double, lon: Double) {
        self.init()
        self.time = time
        self.name = name
        self.placeMemo = placeMemo
        self.lat = lat
        self.lon = lon
    }
}
