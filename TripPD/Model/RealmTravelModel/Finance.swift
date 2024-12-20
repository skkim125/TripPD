//
//  Finance.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 가계부(추후 업데이트)
final class Finance: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var expendTitle: String // 지출 내역
    @Persisted var category: Category // 지출 카테고리
    @Persisted var expend: Int // 지출 비용
    @Persisted var time: Date // 사용 시간
    
    convenience init(id: ObjectId, expendTitle: String, category: Category, expend: Int, time: Date) {
        self.init()
        self.id = id
        self.expendTitle = expendTitle
        self.category = category
        self.expend = expend
        self.time = time
    }
}
