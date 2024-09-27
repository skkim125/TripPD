//
//  MainHomeView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import RealmSwift
import PopupView

struct MainHomeView: View {
    @ObservedObject var travelManager: TravelManager
    @State private var isStarSorted = false
    @State private var showSheet = false
    @State private var showToastView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 20) {
                    Button {
                        if !travelManager.travelList.isEmpty {
                            isStarSorted.toggle()
                        }
                    } label: {
                        Image(systemName: isStarSorted ? "star.fill": "star")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .imageScale(.large).bold()
                            .foregroundStyle(.yellow)
                    }
                    
                    Menu {
                        Button {
                            print("최근 생성순")
                        } label: {
                            Text("최근 생성순")
                            Image(systemName: "list.number")
                        }
                        
                        Button {
                            print("여행 시작일순")
                        } label: {
                            Text("여행 시작일순")
                            Image(systemName: "d.circle")
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .imageScale(.large).bold()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topTrailing)
                .padding(.trailing, 20)
                .padding(.top, 10)
                .tint(.mainApp)
                
                Spacer()
                
                if travelManager.travelList.isEmpty {
                    Text("현재 계획된 여행이 없어요.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.35)
                    
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(travelManager.travelList, id: \.id) { travel in
                                if compareDate(Array(travel.travelDate)) {
                                    NavigationLink {
                                        TravelScheduleListView(travel: travel)
                                    } label: {
                                        TravelCoverView(title: .constant(travel.title), dates: .constant(Array(travel.travelDate)), image: .constant(ImageManager.shared.loadImage(imageName: travel.coverImageURL ?? "")), isStar: .constant(travel.isStar))
                                            .padding(.horizontal, 20)
                                            .padding(.top, 15)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .popup(isPresented: $showToastView) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.mainApp.gradient, lineWidth: 2)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        Text("여행 플래너가 생성되었습니다.")
                            .foregroundStyle(Color(uiColor: .label).gradient)
                            .font(.appFont(14))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 200, height: 40)
                    .padding(.top, 95)
                
            } customize: {
                $0
                    .autohideIn(3)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
                    .type(.toast)
                    .position(.top)
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
                        AddTravelPlannerView(travelManager: travelManager, showSheet: $showSheet, showToastView: $showToastView)
                    }
                }
            }
            .navigationBarTitle(20, 30)
        }
        .onAppear {
            travelManager.detectRealmURL()
            travelManager.travelListForView = travelManager.convertArray()
            print(travelManager.travelListForView)
        }
    }
    
    private func compareDate(_ dateArray: [Date]) -> Bool {
        if let last = dateArray.last, let overday = Calendar.current.date(byAdding: .hour, value: 24, to: last) {
            return Date() < overday
        } else {
            return false
        }
    }
}

#Preview {
    MainHomeView(travelManager: TravelManager.shared)
}
