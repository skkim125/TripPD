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
    @Binding var isStar: Bool
    
    var body: some View {
        if let image = image, let uiimage = UIImage(data: image) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.black.opacity(0.2))
                .background {
                    Image(uiImage: uiimage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 150)
                        .imageScale(.small)
                }
                .overlay {
                    overlayView()
                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        .foregroundStyle(.white.gradient)
                        .padding(.horizontal, 10)
                }
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 1.5)
            
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(.mainApp.gradient)
                .frame(maxWidth: .infinity, alignment: .center)
                .overlay {
                    ZStack {
                        Image(systemName: "airplane")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(-20))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 300)
                            .foregroundStyle(.mainAppConvert.opacity(0.5).gradient)
                            .padding(.leading)
                                
                        overlayView()
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            .foregroundStyle(.white.gradient)
                            .padding(.horizontal, 10)
                    }
                }
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 1.5)
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
        .padding(.top)
    }
    
    @ViewBuilder
    private func dateText(_ dates: [Date]) -> some View {
        let isNotEmpty = !dates.isEmpty
        
        if isNotEmpty {
            if dates.count == 1 {
                if let firstDay = dates.first {
                    let first = firstDay.customDateFormatter(.coverView)
                    Text("\(first)")
                        .font(.appFont(12))
                }
            } else {
                if let firstDay = dates.first, let lastDay = dates.last {
                    let first = firstDay.customDateFormatter(.coverView)
                    let last = lastDay.customDateFormatter(.coverView)
                    Text("\(first) ~ \(last)")
                        .font(.appFont(12))
                }
            }
        }
    }
}

#Preview {
    TravelCoverView(title: .constant("대전 맛집 여행"), dates: .constant([Date(), Date()]), image: .constant(nil), isStar: .constant(false))
}
