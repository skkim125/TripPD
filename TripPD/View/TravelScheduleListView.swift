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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(travel.schedules, id: \.id) { schedule in
                    NavigationLink {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.mainApp.gradient)
                            .frame(width: 165, height: 165)
                            .shadow(radius: 5)
                            .overlay {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(schedule.day)")
                                        .font(.system(size: 35)).bold()
                                        .padding(.top)
                                    
                                    Spacer()
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
        .navigationBarTitle(.mainApp, 20)
        .navigationTitle("\(travel.title)")
        .onAppear {
            dump(travel)
        }
    }
}

#Preview {
    TravelScheduleListView(travelManager: TravelManager.shared, travel: Travel())
}
