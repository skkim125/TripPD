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
    @Namespace var nameSpace
    @StateObject var viewModel: TravelScheduleViewModel
    @State private var selectedTab: Int?
    @State private var showDeleteAlert = false
    @State private var showEditPlacePopupView = false
    @State private var showMapView = false
    @State private var setRegion = false
    
    init(travel: TravelForView) {
        self._viewModel = StateObject(wrappedValue: TravelScheduleViewModel(travel: travel))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(viewModel.output.schedules, id: \.id) { item in
                            ScheduleDayButton(dayString: item.dayString, isSelected: viewModel.output.schedule.id == item.id, nameSpace: nameSpace) {
                                
                                if let tab = viewModel.output.schedules.firstIndex(where: { $0.id == item.id }) {
                                    selectedTab = tab
                                    viewModel.action(action: .changeTab(tab))
                                    setRegion = true
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 35)
                .padding(.horizontal, 10)
                
                calendarView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                
                if viewModel.output.places.isEmpty {
                    Spacer()
                    Label("일정을 만들러 가볼까요?", systemImage: "text.badge.plus")
                        .foregroundStyle(.gray)
                    Spacer()
                } else {
                    
                    PlaceMapView(places: viewModel.output.places, annotations: viewModel.output.annotations, routeCoordinates: viewModel.output.routeCoordinates, selectedPlace: $viewModel.output.goPlaceOnMap, setRegion: $setRegion)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                    
                    placeListView(scehdule: viewModel.output.schedule)
                        .padding(.top, -8)
                }
                
            }
            .popup(isPresented: $showEditPlacePopupView) {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.mainApp.gradient, lineWidth: 2)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        PlaceFormView(schedule: $viewModel.output.schedule, isSelectedPlace: $viewModel.output.editingPlace, showAddPlacePopupView: $showEditPlacePopupView, setRegion: $setRegion, viewType: .edit)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 350)
                    .padding()
                
            } customize: {
                $0
                    .closeOnTap(false)
                    .closeOnTapOutside(false)
                    .type(.floater(verticalPadding: 10, horizontalPadding: 20, useSafeAreaInset: false))
                    .position(.bottom)
                    .dragToDismiss(false)
                    .useKeyboardSafeArea(true)
                    .backgroundView {
                        Color.black.opacity(0.3)
                    }
            }
            .navigationTitle(viewModel.output.travelTitle)
            .navigationBarTitle(20, 30)
            .navigationBarBackButtonHidden()
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("정말로 여행 플랜을 삭제하시겠습니까?"), message: Text("삭제 이후 복구할 수 없습니다."), primaryButton: .cancel(Text("아니요")), secondaryButton: .destructive(Text("예"), action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.action(action: .deleteTravel(viewModel.output.travel))
                    }
                    dismiss()
                }))
            }
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
                            showDeleteAlert.toggle()
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
        .onAppear {
            viewModel.action(action: .loadView(viewModel.output.travel))
            
            guard let index = viewModel.output.schedules.firstIndex(where: { $0.day.customDateFormatter(.dayString) == Date().customDateFormatter(.dayString) }) else {
                
                selectedTab = 0
                viewModel.action(action: .changeTab(0))
                
                return
            }
            
            selectedTab = index
            viewModel.action(action: .changeTab(index))
        }
    }
    
    @ViewBuilder
    func calendarView() -> some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28)
                
                Text("일정")
                    .font(.appFont(25))
            }
            .foregroundStyle(.mainApp)
            
            Spacer()
            
            HStack(spacing: 20) {
                if !viewModel.output.schedule.places.isEmpty {
                    Button {
                        Task { @MainActor in
                            self.setRegion = true
                        }
                    } label: {
                        Image(systemName: "map.circle")
                            .font(.appFont(25)).bold()
                            .foregroundStyle(.mainApp)
                    }
                }
                
                Button {
                    showMapView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.appFont(25)).bold()
                        .foregroundStyle(.mainApp)
                }
            }
            .fullScreenCover(isPresented: $showMapView) {
                LazyWrapperView(AddPlaceMapView(schedule: viewModel.output.schedule, showMapView: $showMapView, setRegion: $setRegion))
            }
        }
    }
    
    @ViewBuilder
    func placeListView(scehdule: ScheduleForView) -> some View {
        SwiftUIList(scehdule.places.sorted(by: { $0.time < $1.time }), id: \.id) { place in
            Button {
                viewModel.action(action: .goPlaceOnMap(place))
            } label: {
                PlaceRowView(schedule: scehdule, place: place)
                    .opacity(viewModel.output.deletePlaceId == place.id ? 0 : 1)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.output.deletePlaceId)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button{
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.action(action: .deletePlace(place.id))
                    }
                    
                    self.setRegion = true
                    
                } label: {
                    Label {
                        Text("삭제")
                    } icon: {
                        Image(systemName: "trash")
                    }
                    
                }
                .tint(.red)
                
                Button{
                    viewModel.action(action: .editingPlace(place))
                    showEditPlacePopupView.toggle()
                } label: {
                    Label {
                        Text("수정")
                    } icon: {
                        Image(systemName: "pencil")
                    }
                    
                }
                .tint(.mainApp)
            }
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowSeparatorTint(.clear)
        }
        .listStyle(.plain)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    TravelScheduleView(travel: TravelForView(travel: Travel()))
}
