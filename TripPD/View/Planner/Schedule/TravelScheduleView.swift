//
//  TravelScheduleView.swift
//  TripPD
//
//  Created by 김상규 on 10/19/24.
//

import SwiftUI
import PopupView

struct TravelScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: TravelScheduleViewModel
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
                            ScheduleDayButton(selectedSchedule: viewModel.travel.schedules[viewModel.selectedTab], schedule: item, dayString: item.dayString, isSelected: viewModel.travel.schedules[viewModel.selectedTab].id == item.id, nameSpace: namespace) {
                                
                                viewModel.selectedTab = viewModel.travel.schedules.firstIndex(where: { $0.id == item.id }) ?? -1
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                
                LazyWrapperView(PlanningScheduleView(schedule: $viewModel.travel.schedules[viewModel.selectedTab]))
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

#Preview {
    TravelScheduleView(travel: TravelForView(travel: Travel()))
}
