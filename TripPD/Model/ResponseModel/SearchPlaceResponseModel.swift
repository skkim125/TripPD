//
//  SearchPlaceResponseModel.swift
//  TripPD
//
//  Created by 김상규 on 9/22/24.
//

import Foundation

struct SearchPlaceResponseModel: Decodable {
    let meta: Meta
    let documents: [PlaceInfo]
}
