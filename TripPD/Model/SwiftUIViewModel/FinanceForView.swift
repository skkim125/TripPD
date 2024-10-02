//
//  FinanceForView.swift
//  TripPD
//
//  Created by 김상규 on 10/2/24.
//

import Foundation

struct FinanceForView {
    var id = UUID().uuidString
    var expendTitle: String // 지출 내역
    var category: Category // 지출 카테고리
    var expend: Int // 지출 비용
    var time: Date // 사용 시간
    
    init(id: String = UUID().uuidString, expendTitle: String, category: Category, expend: Int, time: Date) {
        self.id = id
        self.expendTitle = expendTitle
        self.category = category
        self.expend = expend
        self.time = time
    }
    
    init(finance: Finance) {
        self.id = finance.id.stringValue
        self.expendTitle = finance.expendTitle
        self.category = finance.category
        self.expend = finance.expend
        self.time = finance.time
    }
}
