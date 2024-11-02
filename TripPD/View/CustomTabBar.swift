//
//  CustomTabBar.swift
//  TripPD
//
//  Created by 김상규 on 9/19/24.
//

import SwiftUI
import MapKit
import PopupView

struct CustomTabBar: View {
    @ObservedObject var viewModel: CustomTabBarViewModel
    @Namespace var animation
    @State private var showToast: Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
        self.viewModel = CustomTabBarViewModel()
    }
    
    var body: some View {
        ZStack(alignment: .init(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $viewModel.selectedTab) {
                LazyWrapperView(MainHomeView(showToast: $showToast, hideTabBar: $viewModel.hideTabBar))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(Tab.home)
                
                LazyWrapperView(UserView(hideTabBar: $viewModel.hideTabBar))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(Tab.setting)
            }
            .popup(isPresented: $showToast) {
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
                    .padding(.bottom, 130)
                
            } customize: {
                $0
                    .autohideIn(1.5)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
                    .type(.toast)
                    .position(.bottom)
            }
            
            ZStack {
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
            .offset(y: viewModel.hideTabBar ? 150 : 0) 
            .animation(.easeInOut(duration: 0.3), value: viewModel.hideTabBar)
        }
        .sheet(isPresented: $viewModel.showSheet) {
            AddTravelPlannerView(showSheet: $viewModel.showSheet, showToast: $showToast)
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
