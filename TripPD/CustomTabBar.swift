//
//  CustomTabBar.swift
//  TripPD
//
//  Created by 김상규 on 9/19/24.
//

import SwiftUI

struct CustomTabBar: View {
    var travelManager: TravelManager
    @State private var currentTab = "house"
    @Namespace var animation
    
    init(_ travelManager: TravelManager) {
        UITabBar.appearance().isHidden = true
        self.travelManager = travelManager
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .init(horizontal: .center, vertical: .bottom)) {
                TabView(selection: $currentTab) {
                    LazyWrapperView(MainHomeView(travelManager: travelManager))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(tabs[0])
                    
                    LazyWrapperView(TravelMapView())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(tabs[1])
                    
                    LazyWrapperView(UserView())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(tabs[2])
                }
                
                HStack(spacing: 35) {
                    ForEach(tabs, id: \.self) { tabImage in
                        TabBarButton(image: tabImage, selected: $currentTab, animation: animation)
                    }
                }
                .frame(height: 20)
                .padding(.horizontal, 30)
                .padding(.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom != 0 ? geometry.safeAreaInsets.bottom : 15)
                .background(.mainApp.gradient)
                .clipShape(.rect(cornerRadius: 25))
            }
        }
    }
}

struct TabBarButton: View {
    var image: String
    @Binding var selected: String
    var animation: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                selected = image
            }
        } label: {
            VStack {
                Image(systemName: "\(image)")
                    .font(.appFont(25))
                    .foregroundStyle(selected == image ? .white : .black.opacity(0.5))
                    .padding(.top, 10)
                
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 8, height: 8)
                    
                    if selected == image {
                        Circle()
                            .fill(.white)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
    }
}

var tabs = ["house", "map", "gear"]

#Preview {
    CustomTabBar(TravelManager.shared)
}
