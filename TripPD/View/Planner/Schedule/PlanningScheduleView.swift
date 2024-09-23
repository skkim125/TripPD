//
//  PlanningScheduleView.swift
//  TripPD
//
//  Created by 김상규 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct PlanningScheduleView: View {
    @ObservedRealmObject var schedule: Schedule
    @State private var showMapView = false
    
    var body: some View {
        ScrollView(.vertical) {
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
                LazyVStack {
                    ForEach(schedule.places) { place in
                        
                    }
                }
            }
        }
        .navigationTitle("\(schedule.dayString)")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle(20, 30)
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
                    AddPlaceMapView(showMapView: $showMapView)
                }
            }
        }
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

#Preview {
    PlanningScheduleView(schedule: .init(day: Date(), dayString: "", places: List<Place>(), photos: List<String>(), finances: List<Finance>()))
}
