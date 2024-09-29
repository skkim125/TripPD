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
//    @State private var sortType: SortType = .def
    @Binding var showToastView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
//                HStack(spacing: 20) {
//                    Button {
//                        if !travelManager.travelList.isEmpty {
//                            isStarSorted.toggle()
//                        }
//                    } label: {
//                        Image(systemName: isStarSorted ? "star.fill": "star")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20)
//                            .imageScale(.large).bold()
//                            .foregroundStyle(.yellow)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .topTrailing)
//                .padding(.trailing, 20)
//                .padding(.top, 10)
//                .tint(.mainApp)
                
//                Spacer()
                
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
                                if Date.compareDate(Array(travel.travelDate)) {
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
                    .padding(.bottom, 120)
                
            } customize: {
                $0
                    .autohideIn(2)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
                    .type(.toast)
                    .position(.bottom)
            }
//            .onChange(of: sortType) { newValue in
//                switch newValue {
//                case .closer:
//                    travelManager.travelListForView.sort(by: {
//                        if $0.travelDate.first ?? Date() == $1.travelDate.first ?? Date() {
//                            $0.date < $1.date
//                        } else {
//                            $0.travelDate.first?.timeIntervalSinceNow ?? 0.0 < $1.travelDate.first?.timeIntervalSinceNow ?? 0.0
//                        }
//                    })
//                case .def:
//                    travelManager.travelListForView.sort(by: { $0.date < $1.date })
//                }
//            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Trip PD")
                        .font(.appFont(28))
                        .padding(5)
                        .foregroundStyle(.mainApp.gradient)
                }
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        if !travelManager.travelList.isEmpty {
//                            isStarSorted.toggle()
//                        }
//                    } label: {
//                        Image(systemName: isStarSorted ? "star.fill": "star")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20)
//                            .imageScale(.large).bold()
//                            .foregroundStyle(.yellow)
//                    }
//                }
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Menu {
//                        
//                        Picker("정렬", selection: $sortType) {
//                            ForEach(SortType.allCases) { value in
//                                Text(value.title)
//                            }
//                        }
//                    } label: {
//                        HStack {
//                            Image(systemName: "arrow.up.arrow.down")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20)
//                                .imageScale(.large).bold()
//                        }
//                    }
//                    .font(.appFont(18))
//                    .foregroundStyle(.mainApp.gradient)
//                }
            }
            .navigationBarTitle(20, 30)
        }
//        .onChange(of: showToastView) { _ in
//            travelManager.sortAction(sortType: sortType)
//        }
        .onAppear {
            travelManager.detectRealmURL()
//            travelManager.sortAction(sortType: sortType)
        }
    }
}

#Preview {
    MainHomeView(travelManager: TravelManager.shared, showToastView: .constant(false))
}

enum SortType: String, CaseIterable, Identifiable {
    case def
    case closer
    
    var id: Self {
        return self
    }
    
    var title: String {
        switch self {
        case .def:
            "최근 등록순"
        case .closer:
            "여행일 가까운 순"
        }
    }
}
