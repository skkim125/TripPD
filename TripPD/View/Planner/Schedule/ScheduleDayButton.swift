//
//  CustomTabButton.swift
//  TripPD
//
//  Created by 김상규 on 10/19/24.
//

import SwiftUI

struct ScheduleDayButton: View {
    let dayString: String
    let isSelected: Bool
    let nameSpace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Text("\(dayString)")
                    .padding(.horizontal, 5)
                    .foregroundColor(isSelected ? .mainApp : .gray)
                    .font(.appFont(16))
                
                if isSelected {
                    Color.mainApp
                        .frame(height: 2)
                        .clipShape(Capsule())
                        .padding(.horizontal, 5)
                        .matchedGeometryEffect(id: "underline",
                                               in: nameSpace.self)
                } else {
                    Color.clear.frame(height: 2)
                        .clipShape(Capsule())
                        .padding(.horizontal, 5)
                }
            }
        }
    }
}

//#Preview {
//    ScheduleDayButton(dayString: "Day 1", isSelected: true, nameSpace: Namespace().wrappedValue) {
//        
//    }
//}
