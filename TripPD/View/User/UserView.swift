//
//  UserView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import MessageUI

struct UserView: View {
    
    var body: some View {
        NavigationStack {
            List(Settings.allCases, id: \.self) { item in
                NavigationLink {
                    switch item {
                    case .pastTrip:
                        EmptyView()
                    case .inquiry:
                        EmptyView()
                    case .appInfo:
                        AppInfoView()
                    }
                } label: {
                    Text("\(item.rawValue)")
                        .font(.appFont(15))
                }
                .listStyle(.plain)
            }
            .navigationBarTitle(20, 30)
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.large)
//            ForEach(Settings.allCases, id: \.self) { item in
//                switch item {
//                case .inquiry:
//                    Button {
//                        print("dd")
//                    } label: {
//                        settingRowView(item)
//                    }
//                case .pastTrip:
//                    NavigationLink {
//                        EmptyView()
//                    } label: {
//                        settingRowView(item)
//                    }
//                    
//                case .appInfo:
//                    <#code#>
//                }
//            }
        }
    }
    
//    @ViewBuilder
//    func settingRowView(_ setting: Settings) -> some View {
//        
//        Text("\(setting.rawValue)")
//            .foregroundStyle(.mainApp)
//            .font(.appFont(15))
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .center)
//            .background(.background)
//            .overlay {
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(.mainApp, lineWidth: 5)
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//            .padding(.horizontal)
//    }
}

enum Settings: String, CaseIterable {
    case pastTrip = "지나간 여행 보기"
    case inquiry = "개발자에게 문의하기"
    case appInfo = "앱 정보"
}

#Preview {
    UserView()
}
