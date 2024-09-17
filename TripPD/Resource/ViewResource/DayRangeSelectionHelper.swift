//
//  DayRangeSelectionHelper.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import SwiftUI
import HorizonCalendar

enum DayRangeSelectionHelper {

  static func updateDayRange(
    afterTapSelectionOf day: DayComponents,
    existingDayRange: inout DayComponentsRange?)
  {
    if
      let _existingDayRange = existingDayRange,
      _existingDayRange.lowerBound == _existingDayRange.upperBound,
      day > _existingDayRange.lowerBound
    {
      existingDayRange = _existingDayRange.lowerBound...day
    } else {
      existingDayRange = day...day
    }
  }

  static func updateDayRange(
    afterDragSelectionOf day: DayComponents,
    existingDayRange: inout DayComponentsRange?,
    initialDayRange: inout DayComponentsRange?,
    state: UIGestureRecognizer.State,
    calendar: Calendar)
  {
    switch state {
    case .began:
      if day != existingDayRange?.lowerBound, day != existingDayRange?.upperBound {
        existingDayRange = day...day
      }
      initialDayRange = existingDayRange

    case .changed, .ended:
      guard let initialDayRange else {
        fatalError("`initialDayRange` should not be `nil`")
      }

      let startingLowerDate = calendar.date(from: initialDayRange.lowerBound.components)!
      let startingUpperDate = calendar.date(from: initialDayRange.upperBound.components)!
      let selectedDate = calendar.date(from: day.components)!

      let numberOfDaysToLowerDate = calendar.dateComponents(
        [.day],
        from: selectedDate,
        to: startingLowerDate).day!
      let numberOfDaysToUpperDate = calendar.dateComponents(
        [.day],
        from: selectedDate,
        to: startingUpperDate).day!

      if
        abs(numberOfDaysToLowerDate) < abs(numberOfDaysToUpperDate) ||
        day < initialDayRange.lowerBound
      {
        existingDayRange = day...initialDayRange.upperBound
      } else if
        abs(numberOfDaysToLowerDate) > abs(numberOfDaysToUpperDate) ||
        day > initialDayRange.upperBound
      {
        existingDayRange = initialDayRange.lowerBound...day
      }

    default:
      existingDayRange = nil
      initialDayRange = nil
    }
  }

}
