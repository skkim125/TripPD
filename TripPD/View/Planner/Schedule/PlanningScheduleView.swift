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
    
    init(schedule: ScheduleForView) {
        self.viewModel = PlanningScheduleViewModel(schedule: schedule)
    }
    
    var body: some View {
        VStack {
            calendarView()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.mainApp)
                .padding(.init(top: 10, leading: 20, bottom: 0, trailing: 20))
            
            Spacer()
            
            placeListView()
        }
    }
}
    

// MARK: ViewBuilder
extension PlanningScheduleView {
    @ViewBuilder
    func calendarView() -> some View {
        HStack {
            Image(systemName: "calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 28)
            
            Text("일정")
                .font(.appFont(25))
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func placeListView() -> some View {
        if viewModel.output.schedule.places.isEmpty {
            Label("일정을 만들러 가볼까요?", systemImage: "text.badge.plus")
                .foregroundStyle(.gray)
                .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.35)
        } else {
            SwiftUIList {
                ForEach(viewModel.output.schedule.places.sorted(by: { $0.time < $1.time }), id: \.id) { place in
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
                }
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .listRowSeparatorTint(.clear)
            }
            .listStyle(.plain)
        }
    }
}

//#Preview {
//    PlanningScheduleView(schedule: .init(day: Date(), dayString: "", places: List<Place>(), photos: List<String>(), finances: List<Finance>()))
//}
