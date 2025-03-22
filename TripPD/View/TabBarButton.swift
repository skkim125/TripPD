//
//  TabBarButton.swift
//  TripPD
//
//  Created by 김상규 on 10/5/24.
//

import SwiftUI

struct TabBarButton: View {
    @ObservedObject var viewModel: CustomTabBarViewModel
    var tab: Tab
    var animation: Namespace.ID
    @Binding var selected: Tab
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                viewModel.action(action: .clickedTab(tab))
            }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: tab.rawValue)
                    .font(.appFont(20))
                    .foregroundStyle(selected == tab ? .ultraThickMaterial : .ultraThinMaterial)
                    .padding(.top, 10)
                
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 5, height: 5)
                    
                    if selected == tab {
                        Circle()
                            .fill(.ultraThickMaterial)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                            .frame(width: 5, height: 5)
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .padding(.all, 15)
    }
}

//#Preview {
//    TabBarButton(tab: <#Tab#>, selected: <#Binding<Tab>#>, animation: <#Namespace.ID#>)
//}
