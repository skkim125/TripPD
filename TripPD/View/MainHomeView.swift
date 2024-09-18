//
//  MainHomeView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import RealmSwift

struct MainHomeView: View {
    @ObservedObject var travelManager: TravelManager
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .imageScale(.large).bold()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topTrailing)
                .padding(.trailing, 20)
                .padding(.top)
                .tint(.mainApp)
                
                Spacer()
                
                if travelManager.travelListForView.isEmpty {
                    Text("현재 계획된 여행이 없어요.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                } else {
                    ScrollView {
                        ForEach(travelManager.travelListForView, id: \.id) { travel in
                            NavigationLink {
                                TravelScheduleListView(travelManager: travelManager, travel: travel)
                            } label: {
                                TravelCoverView(title: .constant(travel.title), dates: .constant(Array(travel.travelDate)), image: .constant(ImageManager.shared.loadImage(imageName: travel.coverImageURL ?? "")))
                                    .padding(.horizontal, 20)
                                    .padding(.top, 15)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Trip PD")
                        .font(.appFont(28))
                        .padding(5)
                        .foregroundStyle(.mainApp.gradient)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                    }
                    .font(.appFont(18))
                    .foregroundStyle(.appBlack.gradient)
                    .fullScreenCover(isPresented: $showSheet) {
                        AddTravelPlannerView(travelManager: travelManager, showSheet: $showSheet)
                    }
                }
            }
        }
        .onAppear {
            travelManager.detectRealmURL()
            travelManager.travelListForView = travelManager.convertArray()
        }
    }
}

#Preview {
    MainHomeView(travelManager: TravelManager.shared)
}
