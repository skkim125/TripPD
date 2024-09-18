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
    
    var body: some View {
        Text("\(travel.date)")
    }
}

#Preview {
    TravelScheduleListView(travelManager: TravelManager.shared, travel: Travel())
}
