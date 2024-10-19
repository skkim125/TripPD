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
    @State private var isScrollEnabled: Bool = true
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
                                
                                withAnimation(.spring()) {
                                    selectedTab = viewModel.travel.schedules.firstIndex(where: { $0.id == item.id }) ?? -1
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                
                PlanningScheduleView(schedule: viewModel.travel.schedules[selectedTab])
                    .toolbar {
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
                            Button {
                                showMapView.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.appFont(20)).bold()
                            }
                            .tint(.mainApp)
                            .fullScreenCover(isPresented: $showMapView) {
                                LazyWrapperView(AddPlaceMapView(schedule: viewModel.travel.schedules[selectedTab], showMapView: $showMapView))
                            }
                        }
                    }
            }
            .navigationTitle(viewModel.travel.title)
            .navigationBarTitle(20, 30)
            .navigationBarBackButtonHidden()
        }
    }
}


#Preview {
    TravelScheduleView(travel: TravelForView(travel: Travel()))
}
