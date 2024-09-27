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
    @State private var showSheet = false
    @State private var showToastView = false
    
    @Namespace var animation
    
    init(_ travelManager: TravelManager) {
        UITabBar.appearance().isHidden = true
        self.travelManager = travelManager
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .init(horizontal: .center, vertical: .bottom)) {
                TabView(selection: $currentTab) {
                    LazyWrapperView(MainHomeView(travelManager: travelManager, showToastView: $showToastView))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(tabs[0])
                    
                    LazyWrapperView(UserView())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(tabs[1])
                }
                
                LazyHStack(spacing: 150) {
                    ForEach(tabs, id: \.self) { tabImage in
                        TabBarButton(image: tabImage, selected: $currentTab, animation: animation)
                    }
                }
                .frame(height: 10)
                .padding(.horizontal, 20)
                .padding(.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom != 0 ? geometry.safeAreaInsets.bottom : 5)
                .background(.mainApp)
                .clipShape(.capsule)
                .shadow(radius: 5)
                
                
                Circle()
                    .fill(.mainApp)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.appFont(50))
                                .foregroundStyle(.mainApp, .ultraThickMaterial)
                        }
                    }
                    .offset(y: -15)
            }
        }
        .sheet(isPresented: $showSheet) {
            AddTravelPlannerView(travelManager: travelManager, showSheet: $showSheet, showToastView: $showToastView)
                .ignoresSafeArea()
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
                    .font(.appFont(20))
                    .foregroundStyle(selected == image ? .ultraThickMaterial : .ultraThinMaterial)
                    .padding(.top, 10)
                
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 5, height: 5)
                    
                    if selected == image {
                        Circle()
                            .fill(.ultraThickMaterial)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                            .frame(width: 5, height: 5)
                    }
                }
            }
        }
    }
}

var tabs = ["house", "gear"]

#Preview {
    CustomTabBar(TravelManager.shared)
}
