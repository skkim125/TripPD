//
//  MainHomeView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI

struct MainHomeView: View {
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Trip PD")
                        .font(.custom("OTJalpullineunoneulM", size: 28))
                        .padding(5)
                        .foregroundStyle(.mainApp.gradient)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .font(.custom("OTJalpullineunoneulM", size: 25))
                    .foregroundStyle(.subColor2.gradient)
                    .fullScreenCover(isPresented: $showSheet) {
                        AddTravelPlannerView(showSheet: $showSheet)
                    }
                }
            }
        }
    }
}

#Preview {
    MainHomeView()
}
