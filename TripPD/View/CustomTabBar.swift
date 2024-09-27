//
//  CustomTabBar.swift
//  TripPD
//
//  Created by 김상규 on 9/19/24.
//

import SwiftUI
import MapKit

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
                
                LazyHStack(spacing: 35) {
                    ForEach(tabs, id: \.self) { tabImage in
                        TabBarButton(image: tabImage, selected: $currentTab, animation: animation)
                    }
                }
                .frame(height: 10)
                .padding(.horizontal, 20)
                .padding(.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom != 0 ? geometry.safeAreaInsets.bottom : 10)
                .background(.mainApp.gradient)
                .clipShape(.capsule)
                .shadow(radius: 5)
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
                    .foregroundStyle(selected == image ? .ultraThickMaterial : .ultraThinMaterial)
                    .padding(.top, 15)
                
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 8, height: 8)
                    
                    if selected == image {
                        Circle()
                            .fill(.ultraThickMaterial)
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