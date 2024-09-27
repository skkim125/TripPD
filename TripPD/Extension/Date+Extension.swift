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
        case .dayString:
            dateformat.dateFormat = "M월 d일"
            
        case .coverView:
            dateformat.dateFormat = "yyyy년 M월 d일"
            
        case .scheduleViewMonth:
            dateformat.dateFormat = "M월"
            
        case .scheduleViewDay:
            dateformat.dateFormat = "d일"
            
        case .onlyTime:
            dateformat.dateFormat = "HH시 mm분"
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
    case dayString
    case coverView
    case scheduleViewMonth
    case scheduleViewDay
    case onlyTime
}
