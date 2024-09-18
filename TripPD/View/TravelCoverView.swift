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
    @Binding var image: Data?
    
    var body: some View {
        if let image = image, let uiimage = UIImage(data: image) {
            RoundedRectangle(cornerRadius: 12)
                .background {
                    Image(uiImage: uiimage)
                        .resizable()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 150)
                        .imageScale(.small)
                }
                .overlay {
                    overlayView()
                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        .foregroundStyle(Color(uiColor: .label).gradient)
                        .padding(.horizontal, 10)
                }
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.thinMaterial.opacity(0.7))
            
        } else {
            RoundedRectangle(cornerRadius: 12)
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay {
                    ZStack {
                        Image(systemName: "airplane")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(-20))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 300)
                            .foregroundStyle(.mainApp.opacity(0.5).gradient)
                                
                        overlayView()
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            .foregroundStyle(Color(uiColor: .label).gradient)
                            .padding(.horizontal, 10)
                    }
                }
                .background(.mainApp)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.mainAppConvert.gradient)
        }
    }
    
}

// MARK: ViewBuilder
extension TravelCoverView{
    @ViewBuilder
    private func overlayView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            
            Text("\(title)")
                .font(.appFont(28))
            
            dateText(dates)
        }
        .frame(height: 100)
    }
    
    @ViewBuilder
    private func dateText(_ dates: [Date]) -> some View {
        let isNotEmpty = !dates.isEmpty
        
        if isNotEmpty {
            if dates.count == 1 {
                if let firstDay = dates.first {
                    let first = DateFormatter.customDateFormatter(date: firstDay, .coverView)
                    Text("\(first)")
                        .font(.appFont(12))
                }
            } else {
                if let firstDay = dates.first, let lastDay = dates.last {
                    let first = DateFormatter.customDateFormatter(date: firstDay, .coverView)
                    let last = DateFormatter.customDateFormatter(date: lastDay, .coverView)
                    Text("\(first) ~ \(last)")
                        .font(.appFont(12))
                }
            }
        }
    }
}
