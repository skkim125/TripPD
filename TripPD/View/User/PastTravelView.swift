//
//  PastTravelView.swift
//  TripPD
//
//  Created by 김상규 on 9/28/24.
//

import SwiftUI

struct PastTravelView: View {
    @Environment(\.dismiss) var dismiss
    private let viewModel = PastTravelViewModel()
    
    var body: some View {
        VStack {
            if viewModel.output.pastTravels.isEmpty {
                Text("아직 지나간 여행이 없어요.")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.35)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.output.pastTravels, id: \.id) { travel in
//                            NavigationLink {
//                                TravelScheduleListView(travel: travel)
//                            } label: {
                            let image = ImageManager.shared.loadImage(imageName: travel.coverImageURL)
                            
                            let travelForAdd = TravelForAdd(title: travel.title, travelConcept: travel.travelConcept ?? "", dates: travel.travelDate, image: image, isStar: travel.isStar)
                            
                            TravelCoverView(travel: travelForAdd)
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
