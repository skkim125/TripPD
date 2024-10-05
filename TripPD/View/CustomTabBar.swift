//
//  CustomTabBar.swift
//  TripPD
//
//  Created by 김상규 on 9/19/24.
//

import SwiftUI
import MapKit

struct CustomTabBar: View {
    @ObservedObject var travelManager: TravelManager
    @ObservedObject var viewModel: CustomTabBarViewModel
    
    @Namespace var animation
    
    init() {
        UITabBar.appearance().isHidden = true
        self.travelManager = TravelManager.shared
        self.viewModel = CustomTabBarViewModel()
    }
    
    var body: some View {
        ZStack(alignment: .init(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $viewModel.selectedTab) {
                LazyWrapperView(MainHomeView(travelManager: travelManager, viewModel: MainHomeViewModel(showToastView: viewModel.showToastView)))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(Tab.home)
                
                LazyWrapperView(UserView())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(Tab.setting)
            }
            
            LazyHStack(spacing: 80) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabBarButton(tab: tab, selected: $viewModel.selectedTab, viewModel: viewModel, animation: animation)
                }
            }
            .frame(width: nil, height: 60)
            .background(.mainApp)
            .clipShape(.capsule)
            .padding(.horizontal, 20)
            .padding(.all, 10)
            .shadow(radius: 5)
            
            Circle()
                .fill(.mainApp)
                .frame(width: 60, height: 60)
                .overlay {
                    Button {
                        viewModel.action(action: .showSheet)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.appFont(50))
                            .foregroundStyle(.mainApp, .ultraThickMaterial)
                    }
                }
                .padding(.bottom, 25)
        }
        .sheet(isPresented: $viewModel.showSheet) {
            AddTravelPlannerView(viewModel: viewModel)
                .ignoresSafeArea()
        }
    }
}

enum Tab: String, CaseIterable {
    case home = "house"
    case setting = "gear"
}

#Preview {
    CustomTabBar()
}
