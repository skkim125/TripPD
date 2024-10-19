//
//  CustomTabButton.swift
//  TripPD
//
//  Created by 김상규 on 10/19/24.
//

import SwiftUI

struct ScheduleDayButton: View {
    let selectedSchedule: ScheduleForView
    let schedule: ScheduleForView
    let dayString: String
    let isSelected: Bool
    let nameSpace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text("\(dayString)")
                    .padding(.all, 10)
                    .foregroundColor(isSelected ? .mainApp : .gray)
                    .font(.appFont(17))
                
                if selectedSchedule.id == schedule.id {
                    Color.mainApp
                        .frame(height: 2)
                        .clipShape(Capsule())
                        .matchedGeometryEffect(id: "underline",
                                               in: nameSpace.self)
                } else {
                    Color.clear.frame(height: 2)
                        .clipShape(Capsule())
                }
            }
        }
    }
}

#Preview {
    ScheduleDayButton(selectedSchedule: ScheduleForView(schedule: Schedule()), schedule: ScheduleForView(schedule: Schedule()), dayString: "Day 1", isSelected: true, nameSpace: Namespace().wrappedValue) {
        
    }
}
