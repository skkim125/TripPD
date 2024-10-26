//
//  PlanningScheduleView.swift
//  TripPD
//
//  Created by 김상규 on 9/20/24.
//

import SwiftUI
import RealmSwift
import MapKit
import PopupView

struct PlanningScheduleView: View {
    @ObservedObject var viewModel: PlanningScheduleViewModel
    @State private var showMapView: Bool = false
    @State private var setRegion: Bool = false
    @State private var mapCameraStatus: Bool = false
    @State private var showEditPlacePopupView: Bool = false
    @State private var time = Date()
    @State private var placeMemo = ""
    
    init(schedule: ScheduleForView) {
        self.viewModel = PlanningScheduleViewModel(schedule: schedule)
    }
    
    var body: some View {
        VStack {
            calendarView()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.mainApp)
                .padding(.init(top: 10, leading: 20, bottom: 0, trailing: 20))
            
            if viewModel.output.schedule.places.isEmpty {
                Spacer()
                Label("일정을 만들러 가볼까요?", systemImage: "text.badge.plus")
                    .foregroundStyle(.gray)
                Spacer()
            } else {
                Spacer()
                
                PlaceMapView(places: $viewModel.output.schedule.places, annotations: $viewModel.output.annotations, selectedPlace: $viewModel.output.seletePlace, setRegion: $setRegion, mapCameraStatus: $mapCameraStatus, routeCoordinates: $viewModel.output.routeCoordinates)
                    .onAppear {
                        mapCameraStatus = false
                    }
                
                placeListView()
                    .padding(.top, -8)
            }
        }
        .popup(isPresented: $showEditPlacePopupView) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.mainApp.gradient, lineWidth: 2)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    LazyWrapperView(AddPlaceView(schedule: viewModel.output.schedule, isSelectedPlace: $viewModel.output.editPlace, showAddPlacePopupView: $showEditPlacePopupView, travelTime: $time, placeMemo: $placeMemo, viewType: .constant(.edit)))
                        .onTapGesture {
                            hideKeyboard()
                        }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 350)
                .padding()
            
        } customize: {
            $0
                .closeOnTap(false)
                .closeOnTapOutside(false)
                .type(.floater(verticalPadding: 10, horizontalPadding: 20, useSafeAreaInset: true))
                .position(.bottom)
                .dragToDismiss(false)
                .useKeyboardSafeArea(true)
                .backgroundView {
                    Color.black.opacity(0.3)
                }
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
            
            HStack(spacing: 10) {
                if !viewModel.output.annotations.isEmpty {
                    Button {
                        DispatchQueue.main.async {
                            setRegion.toggle()
                            viewModel.output.seletePlace = nil
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            setRegion.toggle()
                            mapCameraStatus = false
                        }
                    } label: {
                        Image(systemName: "map.circle")
                            .font(.appFont(20)).bold()
                            .foregroundStyle(!mapCameraStatus ? .gray : .mainApp)
                    }
                    .disabled(!mapCameraStatus)
                }
                
                Button {
                    showMapView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.appFont(20)).bold()
                        .foregroundStyle(.mainApp)
                }
            }
            .fullScreenCover(isPresented: $showMapView) {
                LazyWrapperView(AddPlaceMapView(schedule: viewModel.output.schedule, showMapView: $showMapView))
            }
        }
    }
    
    @ViewBuilder
    func placeListView() -> some View {
        SwiftUIList(viewModel.output.schedule.places.sorted(by: { $0.time < $1.time }), id: \.id) { place in
            Button {
                withAnimation {
                    viewModel.action(action: .selectPlace(place))
                }
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
                
                Button{
                    showEditPlacePopupView = true
                    viewModel.action(action: .editPlaceAction(place.id))
                    time = viewModel.output.editPlace?.time ?? Date()
                    placeMemo = viewModel.output.editPlace?.placeMemo ?? ""
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
    }
}

//#Preview {
//    PlanningScheduleView(schedule: .init(day: Date(), dayString: "", places: List<Place>(), photos: List<String>(), finances: List<Finance>()))
//}
