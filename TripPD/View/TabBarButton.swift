//
//  TabBarButton.swift
//  TripPD
//
//  Created by 김상규 on 10/5/24.
//

import SwiftUI

struct TabBarButton: View {
    var tab: Tab
    @Binding var selected: Tab
    @ObservedObject var viewModel: CustomTabBarViewModel
    var animation: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                viewModel.action(action: .clickedTab(selected))
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
