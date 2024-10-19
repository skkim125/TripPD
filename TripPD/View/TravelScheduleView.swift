//
//  TravelScheduleView.swift
//  TripPD
//
//  Created by 김상규 on 10/19/24.
//

import SwiftUI

struct TravelScheduleView: View {
    @State var travel: TravelForView
    @State private var selectedTab = 0
    @Namespace var namespace
    @State private var contentWidth: CGFloat = .zero
    @State private var isScrollEnabled: Bool = true

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(travel.schedules, id: \.id) { item in
                        ScheduleDayButton(selectedSchedule: travel.schedules[selectedTab], schedule: item, dayString: item.day.convertDay(dates: travel.travelDate), isSelected: travel.schedules[selectedTab].id == item.id, nameSpace: namespace) {
                            
                            withAnimation(.spring()) {
                                selectedTab = travel.schedules.firstIndex(where: { $0.id == item.id }) ?? -1
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            PlanningScheduleView(schedule: travel.schedules[selectedTab])
        }
    }
}


#Preview {
    TravelScheduleView(travel: TravelForView(travel: Travel()))
}
