//
//  LaunchScreen.swift
//  TripPD
//
//  Created by 김상규 on 9/28/24.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("나만의 국내여행 플래너")
                .font(.appFont(15))
            
            Text("Trip PD")
                .font(.appFont(55))
        }
        .foregroundStyle(.mainApp.gradient)
    }
}

#Preview {
    LaunchScreen()
}
