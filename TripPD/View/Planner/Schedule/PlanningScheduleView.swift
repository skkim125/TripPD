//
//  PlanningScheduleView.swift
//  TripPD
//
//  Created by 김상규 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct PlanningScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    var schedule: ScheduleForView
    @State private var showMapView = false
    @State private var deletedPlaceId: String?
    
    var body: some View {
        VStack {
            calendarView()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.mainApp)
                .padding(.init(top: 10, leading: 20, bottom: 0, trailing: 20))
            
            Spacer()
            
            if schedule.places.isEmpty {
                Label("일정을 만들러 가볼까요?", systemImage: "text.badge.plus")
                    .foregroundStyle(.gray)
                    .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.35)
            } else {
                SwiftUIList {
                    ForEach(Array(schedule.places).sorted(by: { $0.time < $1.time }), id: \.id) { place in
                        PlaceRowView(schedule: schedule, place: place)
                            .opacity(deletedPlaceId == place.id ? 0 : 1)
                            .animation(.easeInOut(duration: 0.3), value: deletedPlaceId)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button{
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        deletedPlaceId = place.id
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            TravelManager.shared.removePlace(place: place)
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
                                
//                                Button{
//                                    
//                                } label: {
//                                    Label {
//                                        Text("수정")
//                                    } icon: {
//                                        Image(systemName: "pencil")
//                                    }
//                                    
//                                }
//                                .tint(.mainApp)
                            }
                    }
                    .listSectionSeparator(.hidden)
                    .listRowSeparator(.hidden)
                    .listRowSeparatorTint(.clear)
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showMapView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.appFont(20)).bold()
                }
                .tint(.mainApp)
                .fullScreenCover(isPresented: $showMapView) {
                    AddPlaceMapView(schedule: schedule, showMapView: $showMapView)
                }
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
        }
        .navigationTitle("\(schedule.dayString)")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle(20, 30)
        .navigationBarBackButtonHidden()
    }
    
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
}

//#Preview {
//    PlanningScheduleView(schedule: .init(day: Date(), dayString: "", places: List<Place>(), photos: List<String>(), finances: List<Finance>()))
//}
