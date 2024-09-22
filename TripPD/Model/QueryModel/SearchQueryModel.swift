//
//  SearchQueryModel.swift
//  TripPD
//
//  Created by 김상규 on 9/22/24.
//

import Foundation

struct SearchQueryModel: Encodable {
    let sort: SearchSort
    let query: String
    let page: Int
    var size: Int = 15
}

enum SearchSort: String, Encodable {
    case accuracy
    case distance
}
