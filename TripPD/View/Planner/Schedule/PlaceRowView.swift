//
//  PlaceRowView.swift
//  TripPD
//
//  Created by 김상규 on 9/26/24.
//

import SwiftUI
import MapKit

struct PlaceRowView: View {
    var schedule: ScheduleForView
    var place: PlaceForView
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .center) {
                Text("\(place.time.customDateFormatter(.onlyTime))")
                    .font(.appFont(12))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                
                Circle()
                    .fill(.mainApp)
                    .frame(width: 15, height: 15)
                    .padding(3)
                    .background(.white.shadow(.drop(color: .appBlack.opacity(0.2), radius: 3)), in: .circle)
                
                times(place: place)
                    .padding(.top, -8)
            }
            
            let index = schedule.places.sorted(by: { $0.time < $1.time }).firstIndex(where: { $0.id == place.id })
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\((index ?? -2 ) + 1). \(place.name)")
                    .foregroundStyle(.mainApp)
                    .font(.appFont(18))
                    .padding(.horizontal, 5)
                    .padding(.top, 20)
                    .multilineTextAlignment(.leading)
                
                if let memo = place.placeMemo, !memo.isEmpty {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.mainApp, lineWidth: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .background(.clear)
                        .overlay {
                            VStack {
                                HStack {
                                    Text("\(memo)")
                                        .foregroundStyle(.foreground)
                                        .font(.appFont(13))
                                        .padding(.horizontal, 10)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            .padding(.top)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 80)
                        .padding(.leading, 5)
                }
            }
        }
    }
    
    @ViewBuilder
    private func times(place: PlaceForView) -> some View {
        if schedule.places.sorted(by: { $0.time < $1.time }).last?.id != place.id {
            HStack {
                Rectangle()
                    .fill(.mainApp)
                    .frame(width: 2, height: place.placeMemo?.isEmpty ?? true ? 30 : 100)
            }
        } else {
            HStack {
                Text("End")
                    .font(.appFont(14))
                    .foregroundStyle(.mainApp)
                    .padding(.top, 5)
            }
        }
    }
}

//#Preview {
//    PlaceRowView()
//}
