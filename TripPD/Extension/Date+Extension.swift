//
//  Date+Extension.swift
//  TripPD
//
//  Created by 김상규 on 9/19/24.
//

import Foundation

extension Date {
    func customDateFormatter(_ type: DateFormatterType) -> String {
        let dateformat = DateFormatter()
        
        switch type {
        case .day:
            dateformat.dateFormat = "M월 d일"
            
        case .coverView:
            dateformat.dateFormat = "yyyy년 M월 d일"
        }
        
        return dateformat.string(from: self)
    }
    
    func convertDay(dates: [Date]) -> String {
        if let firstDay = dates.first {
            if let compareDay = Calendar.current.dateComponents([.day], from: firstDay, to: self).day {
                return "Day \(compareDay+1)"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

enum DateFormatterType {
    case day
    case coverView
}
