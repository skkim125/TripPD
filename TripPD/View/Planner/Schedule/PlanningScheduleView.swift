//
//  PlanningScheduleView.swift
//  TripPD
//
//  Created by 김상규 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct PlanningScheduleView: View {
    @ObservedObject var viewModel: PlanningScheduleViewModel
    @State private var showMapView: Bool = false
    
    init(schedule: ScheduleForView) {
        self.viewModel = PlanningScheduleViewModel(schedule: schedule)
    }
    
    var body: some View {
        VStack {
            if viewModel.output.schedule.places.isEmpty {
                Spacer()
                Label("일정을 만들러 가볼까요?", systemImage: "text.badge.plus")
                    .foregroundStyle(.gray)
                Spacer()
            } else {
                placeListView()
            }
        }
    }
}
    

// MARK: ViewBuilder
extension PlanningScheduleView {
    @ViewBuilder
    func placeListView() -> some View {
        SwiftUIList(viewModel.output.schedule.places.sorted(by: { $0.time < $1.time }), id: \.id) { place in
            Button {
                
            } label: {
                PlaceRowView(schedule: viewModel.output.schedule, place: place)
                    .opacity(viewModel.output.deletePlaceID == place.id ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.output.deletePlaceID)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button{
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.action(action: .deletePlaceAction(place.id))
                    }
                    print("삭제되었습니다.")
                } label: {
                    Label {
                        Text("삭제")
                    } icon: {
                        Image(systemName: "trash")
                    }
                    
                }
                .tint(.red)
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowSeparatorTint(.clear)
        }
        .listStyle(.plain)
    }
}

//#Preview {
//    PlanningScheduleView(schedule: .init(day: Date(), dayString: "", places: List<Place>(), photos: List<String>(), finances: List<Finance>()))
//}
