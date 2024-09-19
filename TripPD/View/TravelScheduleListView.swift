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
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var showEditView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Array(travel.schedules), id: \.id) { schedule in
                        NavigationLink {
                            
                        } label: {
//                            RoundedRectangle(cornerRadius: 15)
                            Circle()
                                .foregroundStyle(.mainApp.gradient)
                                .frame(width: 165, height: 165)
                                .shadow(radius: 5)
                                .overlay {
                                    VStack(spacing: 10) {
                                        Text("\(schedule.day.convertDay(dates: Array(travel.travelDate)))")
                                            .font(.appFont(30))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.top, 10)
                                        
                                        Text("\(schedule.day.customDateFormatter(.day))")
                                            .font(.appFont(15))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.top, 10)
                                    }
                                    .foregroundStyle(.thickMaterial)
                                    .padding(.vertical, 10)
                                }
                                .padding(10)
                        }
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
            .navigationTitle("\(travel.title)")
        }
    }
}

#Preview {
    TravelScheduleListView(travelManager: TravelManager.shared, travel: Travel())
}
