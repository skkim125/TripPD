//
//  PastTravelView.swift
//  TripPD
//
//  Created by 김상규 on 9/28/24.
//

import SwiftUI

struct PastTravelView: View {
    @Environment(\.dismiss) var dismiss
    var travelManager = TravelManager.shared
    var body: some View {
        VStack {
            if travelManager.travelListForView.filter({ $0.isDelete }).isEmpty {
                Text("아직 지나간 여행이 없어요.")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.35)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(travelManager.travelListForView.filter({ $0.isDelete }), id: \.id) { travel in
//                            NavigationLink {
//                                TravelScheduleListView(travel: travel)
//                            } label: {
                                TravelCoverView(title: .constant(travel.title), dates: .constant(Array(travel.travelDate)), image: .constant(ImageManager.shared.loadImage(imageName: travel.coverImageURL ?? "")), isStar: .constant(travel.isStar))
                                    .padding(.horizontal, 20)
                                    .padding(.top, 15)
//                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.mainApp.gradient)
                        .bold()
                }
            }
        }
        .navigationTitle("지난 여행")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    PastTravelView()
}
