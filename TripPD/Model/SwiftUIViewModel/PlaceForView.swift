//
//  PlaceForView.swift
//  TripPD
//
//  Created by 김상규 on 10/2/24.
//

import Foundation

struct PlaceForView {
    var id = UUID().uuidString
    var time: Date // 시간
    var name: String // 장소 이름
    var address: String // 장소 주소
    var placeMemo: String? // 장소 메모
    var lat: Double // 위도
    var lon: Double // 경도
    var isStar: Bool // 즐겨찾기
    
    init(id: String = UUID().uuidString, time: Date, name: String, address: String, placeMemo: String? = nil, lat: Double, lon: Double, isStar: Bool) {
        self.id = id
        self.time = time
        self.name = name
        self.address = address
        self.placeMemo = placeMemo
        self.lat = lat
        self.lon = lon
        self.isStar = isStar
    }
    
    init(place: Place) {
        self.id = place.id.stringValue
        self.time = place.time
        self.name = place.name
        self.address = place.address
        self.placeMemo = place.placeMemo
        self.lat = place.lat
        self.lon = place.lon
        self.isStar = place.isStar
    }
}
