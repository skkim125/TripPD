//
//  DateFormatter+Extension.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation

extension DateFormatter {
    static func customDateFormatter(date: Date, _ type: DateFormatterType) -> String {
        var dateformat = self.init()
        
        switch type {
        case .day:
            dateformat.dateFormat = "yyyy년 M월 d일"
        case .coverView:
            dateformat.dateFormat = "yyyy년 M월 d일"
        }
        
        return dateformat.string(from: date)
    }
    
    
}

enum DateFormatterType {
    case day
    case coverView
}
