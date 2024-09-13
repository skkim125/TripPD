//
//  AddTravelPlannerView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI

struct AddTravelPlannerView: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.appBlack)
                    }
                }
            }
            .navigationTitle("여행 플랜 생성하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddTravelPlannerView(showSheet: .constant(true))
}
