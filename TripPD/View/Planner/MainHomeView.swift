//
//  MainHomeView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import PopupView

struct MainHomeView: View {
    @ObservedObject private var viewModel: MainHomeViewModel
    @State private var sortType: SortType = .def
    @Binding var showToast: Bool
    @Binding var hideTabBar: Bool
//    @State private var isStarSorted = false
    
    init(showToast: Binding<Bool>, hideTabBar: Binding<Bool>) {
        self.viewModel = MainHomeViewModel()
        self._showToast = showToast
        self._hideTabBar = hideTabBar
    }
    
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
                
                if viewModel.travelListForView.isEmpty  {
                    Text("현재 계획된 여행이 없어요.")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .position(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.35)
                    
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.travelListForView, id: \.id) { travel in
                                if Date.compareDate(Array(travel.travelDate)) {
                                    NavigationLink {
                                        TravelScheduleView(travel: travel)
                                            .onAppear {
                                                hideTabBar = true
                                            }
                                            .onDisappear {
                                                hideTabBar = false
                                            }
                                    } label: {
                                        let image = ImageManager.shared.loadImage(imageName: travel.coverImageURL)
                                        
                                        let travelForAdd = TravelForAdd(title: travel.title, travelConcept: travel.travelConcept ?? "", dates: travel.travelDate, image: image, isStar: travel.isStar)
                                        
                                        TravelCoverView(travel: travelForAdd)
                                            .padding(.horizontal, 20)
                                            .padding(.top, 15)
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("정렬", selection: $sortType) {
                            ForEach(SortType.allCases, id: \.self) { value in
                                Text(value.title)
                                    .tag(value)
                            }
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
                    .font(.appFont(18))
                    .foregroundStyle(.mainApp.gradient)
                    .onChange(of: sortType) { newValue in
                        viewModel.action(action: .sortAction(newValue))
                    }
                }
            }
            .navigationBarTitle(20, 30)
        }
        .onChange(of: showToast) { _ in
            viewModel.action(action: .sortAction(sortType))
        }
        .onAppear {
            viewModel.getRealmURL()
        }
    }
}

//#Preview {
//    MainHomeView(travelManager: TravelManager.shared, showToastView: .constant(false))
//}

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
