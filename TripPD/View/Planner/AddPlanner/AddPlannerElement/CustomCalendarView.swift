//
//  CustomCalendarView.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import SwiftUI
import HorizonCalendar

struct CustomCalendarView: View {
    @State var selectedDayRange: DayComponentsRange?
    @State var selectedStartDate: Date?
    @State var selectedEndDate: Date?
    @Binding var selectedDates: [Date]
    @Binding var showDatePickerView: Bool
    
    var calendar: Calendar = Calendar.current
    var startDate: Date {
        calendar.startOfDay(for: Date())
    }
    var endDate: Date {
        calendar.date(byAdding: .year, value: 1, to: startDate)!
    }
    var visibleDateRange: ClosedRange<Date> {
        startDate...endDate
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = calendar.locale
        dateFormatter.dateFormat = "yyyy년 M월"
        
        return dateFormatter
    }
    
    var navigationTitle: String {
        guard let selectedDayRange else { return "날짜 선택" }
        let selectedStartDate = calendar.date(from: selectedDayRange.lowerBound.components)!
        let selectedEndDate = calendar.date(from: selectedDayRange.upperBound.components)!
        
        if selectedStartDate == selectedEndDate {
            return selectedStartDate.customDateFormatter(.coverView)
        } else {
            
            return "\(selectedStartDate.customDateFormatter(.coverView)) ~ \(selectedEndDate.customDateFormatter(.coverView))"
        }
    }
    
    var selectedDateRanges: Set<ClosedRange<Date>> {
        guard let selectedDayRange else { return [] }
        let selectedStartDate = calendar.date(from: selectedDayRange.lowerBound.components)!
        let selectedEndDate = calendar.date(from: selectedDayRange.upperBound.components)!
        
        return [selectedStartDate...selectedEndDate]
    }
    
    var body: some View {
        VStack {
            VStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        HStack {
                            Button {
                                showDatePickerView = false
                            } label: {
                                Text("닫기")
                                    .font(.appFont(20))
                                    .foregroundStyle(.red)
                            }
                            .padding(.leading, 10)
                            
                            Spacer()
                            
                            Button {
                                selectedDates = transformDates(selectedDateRanges: selectedDateRanges)
                                showDatePickerView = false
                            } label: {
                                Text("저장")
                                    .font(.appFont(20))
                                    .foregroundStyle(!selectedDateRanges.isEmpty ? (Color.mainApp.gradient) : Color.gray.gradient).bold()
                            }
                            .padding(.trailing, 10)
                            .disabled(selectedDateRanges.isEmpty)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 50)
                
                Rectangle()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color(uiColor: .placeholderText).opacity(0.3))
                    .frame(height: 1)
                    .padding(.vertical, -8)
            }
            .padding(.bottom, -15)
            
            CalendarViewRepresentable(
                calendar: calendar,
                visibleDateRange: visibleDateRange ,
                monthsLayout: .vertical(options: .init()),
                dataDependency: nil)
            .interMonthSpacing(20)
            .dayRangeItemProvider(for: selectedDateRanges) { dayRangeLayoutContext in
                let framesOfDaysToHighlight = dayRangeLayoutContext.daysAndFrames.map { $0.frame }
                
                return DayRangeIndicatorView.calendarItemModel(
                    invariantViewProperties: .init(),
                    content: .init(framesOfDaysToHighlight: framesOfDaysToHighlight))
            }
            .days { day in
                calendarTextView(day: day.components, isSelected: isDaySelected(day))
            }
            .monthHeaders { month in
                let monthHeaderText = dateFormatter.string(from: calendar.date(from: month.components)!)
                
                Text(monthHeaderText)
                    .font(.system(size: 18))
                    .foregroundStyle(.mainApp)
            }
            .onDaySelection { day in
                if !isTodayUnder(day.components, calendar.dateComponents(in: .current, from: Date())) {
                    DayRangeSelectionHelper.updateDayRange(
                        afterTapSelectionOf: day,
                        existingDayRange: &selectedDayRange)
                }
            }
            .layoutMargins(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedDates = transformDates(selectedDateRanges: selectedDateRanges)
                        showDatePickerView = false
                    } label: {
                        Text("저장")
                            .font(.appFont(20))
                            .foregroundStyle(.mainApp)
                    }
                }
                
                ToolbarItem(placement: .navigation) {
                    Button {
                        showDatePickerView = false
                    } label: {
                        Text("닫기")
                            .font(.appFont(20))
                            .foregroundStyle(.foreground)
                    }
                }
            }
        }
    }
    
    func transformDates(selectedDateRanges: Set<ClosedRange<Date>>) -> [Date] {
        var dates: [Date] = []
        
        for range in selectedDateRanges {
            var currentDate = calendar.startOfDay(for: range.lowerBound)  // 날짜의 시작 시간으로 설정
            
            while currentDate <= range.upperBound {
                dates.append(currentDate)
                guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDate
                
                print(currentDate)
            }
        }
        
        return dates
    }
}

// MARK: calendarTextView
extension CustomCalendarView {
    func calendarTextView(day: DateComponents, isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .strokeBorder(isSelected ? .mainApp : .clear, lineWidth: 2)
                .background {
                    Circle()
                        .foregroundColor(isSelected ? .white : .clear)
                }
            
            Text("\(day.day!)")
                .font(.system(size: 18))
                .foregroundStyle(isToday(day, calendar.dateComponents(in: .current, from: Date())) ? .white : .mainApp)
                .bold(isToday(day, calendar.dateComponents(in: .current, from: Date())))
                .strikethrough(isTodayUnder(day, calendar.dateComponents(in: .current, from: Date())), pattern: .solid, color: .mainApp)
                .padding(.all, 10)
                .background {
                    Circle()
                        .foregroundColor(isToday(day, calendar.dateComponents(in: .current, from: Date())) ? .mainApp : .clear)
                }
        }
    }
}

// MARK: function
extension CustomCalendarView {
    private func isToday(_ calendarDay: DateComponents, _ today: DateComponents) -> Bool {
        if calendarDay.year == today.year
            && calendarDay.month == today.month
            && calendarDay.day == today.day {
            true
        } else {
            false
        }
    }
    
    private func isTodayUnder(_ calendarDay: DateComponents, _ today: DateComponents) -> Bool {
        if calendarDay.year! <= today.year!
            && calendarDay.month! <= today.month!
            && calendarDay.day! < today.day! {
            true
        } else {
            false
        }
    }
    
    private func isDaySelected(_ day: DayComponents) -> Bool {
        if let selectedDayRange {
            return day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
        } else {
            return false
        }
    }
}

final class DayRangeIndicatorView: UIView {
    private let indicatorColor: UIColor
    
    fileprivate init(indicatorColor: UIColor) {
        self.indicatorColor = indicatorColor
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(indicatorColor.cgColor)
        
        if traitCollection.layoutDirection == .rightToLeft {
            context?.translateBy(x: bounds.midX, y: bounds.midY)
            context?.scaleBy(x: -1, y: 1)
            context?.translateBy(x: -bounds.midX, y: -bounds.midY)
        }
        
        var dayRowFrames = [CGRect]()
        var currentDayRowMinY: CGFloat?
        for dayFrame in framesOfDaysToHighlight {
            if dayFrame.minY != currentDayRowMinY {
                currentDayRowMinY = dayFrame.minY
                dayRowFrames.append(dayFrame)
            } else {
                let lastIndex = dayRowFrames.count - 1
                dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
            }
        }
        
        for dayRowFrame in dayRowFrames {
            let cornerRadius = dayRowFrame.height / 2
            let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: cornerRadius)
            context?.addPath(roundedRectanglePath.cgPath)
            context?.fillPath()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsDisplay()
    }
    
    fileprivate var framesOfDaysToHighlight = [CGRect]() {
        didSet {
            guard framesOfDaysToHighlight != oldValue else { return }
            setNeedsDisplay()
        }
    }
}

extension DayRangeIndicatorView: CalendarItemViewRepresentable {

  struct InvariantViewProperties: Hashable {
    var indicatorColor = UIColor(.mainApp.opacity(0.3))
  }

  struct Content: Equatable {
    let framesOfDaysToHighlight: [CGRect]
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayRangeIndicatorView
  {
    DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
  }

  static func setContent(_ content: Content, on view: DayRangeIndicatorView) {
    view.framesOfDaysToHighlight = content.framesOfDaysToHighlight
  }
}


#Preview {
    CustomCalendarView(selectedDates: .constant([]), showDatePickerView: .constant(true))
}
