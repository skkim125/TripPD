//
//  TravelScheduleView.swift
//  TripPD
//
//  Created by 김상규 on 10/19/24.
//

import SwiftUI

struct TravelScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: TravelScheduleViewModel
    @State private var selectedTab = 0
    @Namespace var namespace
    @State private var contentWidth: CGFloat = .zero
    @State private var showMapView: Bool = false
    
    init(travel: TravelForView) {
        self.viewModel = TravelScheduleViewModel(travel: travel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.travel.schedules, id: \.id) { item in
                            ScheduleDayButton(selectedSchedule: viewModel.travel.schedules[selectedTab], schedule: item, dayString: item.dayString, isSelected: viewModel.travel.schedules[selectedTab].id == item.id, nameSpace: namespace) {
                                
                                selectedTab = viewModel.travel.schedules.firstIndex(where: { $0.id == item.id }) ?? -1
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                
                LazyWrapperView(PlanningScheduleView(schedule: viewModel.travel.schedules[selectedTab]))
            }
            .alert(isPresented: $viewModel.showDeleteAlert) {
                Alert(title: Text("정말로 여행 플랜을 삭제하시겠습니까?"), message: Text("삭제 이후 복구할 수 없습니다."), primaryButton: .cancel(Text("아니요")), secondaryButton: .destructive(Text("예"), action: {
                    viewModel.action(action: .deleteAction)
                    dismiss()
                }))
            }
        }
        .navigationTitle(viewModel.travel.title)
        .navigationBarTitle(20, 30)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.mainApp.gradient)
                        .bold()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        viewModel.action(action: .showDeleteAlert)
                    } label: {
                        Text("여행 삭제")
                        Image(systemName: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .tint(.mainApp)
                
            }
        }
    }
}

extension TravelScheduleView {
    
//    @ViewBuilder
//    func calendarView() -> some View {
//        HStack {
//            Image(systemName: "calendar")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 28)
//            
//            Text("일정")
//                .font(.appFont(25))
//            
//            Spacer()
//            
//            Button {
//                showMapView.toggle()
//            } label: {
//                Image(systemName: "plus")
//                    .font(.appFont(20)).bold()
//            }
//            .tint(.mainApp)
//            .fullScreenCover(isPresented: $showMapView) {
//                LazyWrapperView(AddPlaceMapView(schedule: viewModel.travel.schedules[selectedTab], showMapView: $showMapView))
//            }
//        }
//    }
}

#Preview {
    TravelScheduleView(travel: TravelForView(travel: Travel()))
}
