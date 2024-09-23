//
//  KakaoLocalModel.swift
//  TripPD
//
//  Created by 김상규 on 9/22/24.
//

import Foundation

struct Meta: Decodable {
    let total: Int // total_count
    let pageableCount: Int // pageable_count
    let isEnd: Bool // is_end
    
    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct PlaceInfo: Hashable, Decodable {
    let id: String
    let placeName: String // place_name
    let categoryName: String // category_name
    let address: String // address_name
    let roadAddress: String // road_address_name
    let lat: String // y
    let lon: String // x
    let placeURL: String // place_url
    let distance: String // distance
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "place_name"
        case categoryName = "category_name"
        case address = "address_name"
        case roadAddress = "road_address_name"
        case lat = "y"
        case lon = "x"
        case placeURL = "place_url"
        case distance
    }
}
