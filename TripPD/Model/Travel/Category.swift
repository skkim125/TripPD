//
//  Category.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 지출내역 카테고리(추후 업데이트)
enum Category: String, PersistableEnum {
    case eat // 식사
    case shopping // 쇼핑
    case ticket // 티켓
    case transport // 교통
    case accommodation // 숙박
    case entrance // 입장료
    case etc // 기타
}
