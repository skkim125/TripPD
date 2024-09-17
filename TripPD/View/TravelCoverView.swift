//
//  TravelCoverView.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import SwiftUI

struct TravelCoverView: View {
    @Binding var title: String
    @Binding var dates: [Date]
    @Binding var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 150)
                .imageScale(.small)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.ultraThinMaterial.opacity(0.7))
                        Text("\(title)")
                        
                        if !dates.isEmpty {
                            if dates.count == 1 {
                                if let firstDay = dates.first {
                                    Text("\(firstDay)")
                                        .font(.appFont(18))
                                        .foregroundStyle(.gray)
                                }
                            } else {
                                if let firstDay = dates.first, let lastDay = dates.last {
                                    Text("\(firstDay) ~ \(lastDay)")
                                        .font(.appFont(18))
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            if !dates.isEmpty {
                if let firstDay = dates.first, let lastDay = dates.last {
                    Text("\(firstDay) ~ \(lastDay)")
                        .font(.appFont(18))
                        .foregroundStyle(.gray)
                }
            }
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .background(.mainApp)
                
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(-20))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 300)
                    .foregroundStyle(.mainApp.opacity(0.7).gradient)
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(title)")
                        .font(.appFont(28))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if !dates.isEmpty {
                        if let firstDay = dates.first, let lastDay = dates.last {
                            Text("\(firstDay) ~ \(lastDay)")
                                .font(.appFont(18))
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .foregroundStyle(.black.opacity(0.7))
                .padding(.top, 10)
                .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.subColor3.gradient)
        }
    }
}
