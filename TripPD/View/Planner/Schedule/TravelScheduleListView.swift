//
//  TravelScheduleListView.swift
//  TripPD
//
//  Created by 김상규 on 9/18/24.
//

import SwiftUI
import RealmSwift

struct TravelScheduleListView: View {
    @ObservedObject var travelManager: TravelManager
    @ObservedRealmObject var travel: Travel
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showEditView = false
    
    init(travelManager: TravelManager, travel: Travel, showEditView: Bool = false) {
        self.travelManager = travelManager
        self.travel = travel
        self.showEditView = showEditView
        
        let fontAppearance = UINavigationBarAppearance()
        fontAppearance.titleTextAttributes = [.font: UIFont.appFont(20), .foregroundColor: UIColor.mainApp]
        fontAppearance.largeTitleTextAttributes = [.font: UIFont.appFont(30), .foregroundColor: UIColor.mainApp]
        
        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = fontAppearance
        navBar.prefersLargeTitles = true
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Array(travel.schedules), id: \.id) { schedule in
                        NavigationLink {
                            PlanningScheduleView(schedule: schedule)
                        } label: {
                            scheduleRow(schedule.day.customDateFormatter(.scheduleViewMonth), schedule.day.customDateFormatter(.scheduleViewDay))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        
                    }
                }
                .padding(.init(top: 5, leading: 15, bottom: 0, trailing: 15))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            
                        } label: {
                            Text("수정")
                            Image(systemName: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            
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
        .navigationTitle("\(travel.title)")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle(20, 30)
    }
    
    func scheduleRow(_ month: String, _ day: String) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.mainApp.gradient , lineWidth: 3)
                .frame(width: 110, height: 130)
                .overlay {
                    VStack {
                        Rectangle()
                            .fill(.mainApp.gradient)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .overlay {
                                Text("\(month)")
                                    .font(.appFont(20))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundStyle(.ultraThickMaterial)
                            }
                        
                        Spacer()
                        
                        Text("\(day)")
                            .font(.appFont(40))
                            .foregroundStyle(.mainApp.gradient)
                        
                        Spacer()
                    }
                }
                .background(.clear)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    TravelScheduleListView(travelManager: TravelManager.shared, travel: Travel())
}
