//
//  AppInfoView.swift
//  TripPD
//
//  Created by 김상규 on 9/28/24.
//

import SwiftUI

struct AppInfoView: View {
    @Environment(\.dismiss) var dismiss
    private let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "버전 정보를 불러올 수 없습니다"
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("AppIcon_Setting")
                .resizable()
                .scaledToFit()
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.mainApp, lineWidth: 5)
                }
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .center, spacing: 5) {
                Text("Trip PD")
                    .font(.appFont(20))
                
                Text("ver \(appVersion)")
                    .font(.appFont(14))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 10)
            
            Spacer()
            
            Button {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingsURL)
            } label: {
                Text("오픈소스 라이브러리")
                    .foregroundStyle(.secondary)
                    .padding(6)
            }
            .buttonStyle(.bordered)
            .frame(width: 280)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .tint(.mainApp)
            
            Text("Copyrightⓒ 2024 Trip PD All rights reserved")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 100)
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.mainApp.gradient)
                        .bold()
                }
            }
        }
        .navigationTitle("앱 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppInfoView()
}
