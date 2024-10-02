//
//  Place.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 장소
final class Place: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(indexed: true) var time: Date // 시간
    @Persisted var name: String // 장소 이름
    @Persisted var address: String // 장소 주소
    @Persisted var placeMemo: String? // 장소 메모
    @Persisted var lat: Double // 위도
    @Persisted var lon: Double // 경도
    @Persisted var isStar: Bool // 즐겨찾기
    
    convenience init(time: Date, name: String, address: String , placeMemo: String? = nil, lat: Double, lon: Double, isStar: Bool = false) {
        self.init()
        self.time = time
        self.name = name
        self.address = address
        self.placeMemo = placeMemo
        self.lat = lat
        self.lon = lon
        self.isStar = isStar
    }
}
