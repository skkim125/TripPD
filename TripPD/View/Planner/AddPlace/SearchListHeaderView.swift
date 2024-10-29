//
//  SearchListHeaderView.swift
//  TripPD
//
//  Created by 김상규 on 9/24/24.
//

import SwiftUI
import BottomSheet

struct SearchListHeaderView: View {
    private let networkMonitor = NetworkMonitor.shared
    @ObservedObject var kakaoLocalManager = KakaoLocalManager.shared
    
    @Binding var annotations: [CustomAnnotation]
    @Binding var sheetHeight: BottomSheetPosition
    @Binding var isSelected: Bool
    @Binding var isSearched: Bool
    @Binding var showNoResults: Bool
    
    @State private var query = ""
    @Binding var showNetworkErrorAlert: Bool
    @Binding var showNetworkErrorAlertTitle: String
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 50, height: 5, alignment: .center)
                .foregroundStyle(.gray.opacity(0.5))
                .padding(.top, 5)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.appFont(15))
                    .foregroundStyle(.gray)
                
                TextField("검색", text: $query)
                    .keyboardType(.webSearch)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .onSubmit {
                        withAnimation {
                            if !annotations.isEmpty {
                                annotations.removeAll()
                            }
                            isSelected = false
                            isSearched = true
                            sheetHeight = .dynamicBottom
                            DispatchQueue.main.async {
                                kakaoLocalManager.searchPlace(sort: .accuracy, query, page: 1) { result in
                                    if networkMonitor.isConnected {
                                        switch result {
                                        case .success(let success):
                                            kakaoLocalManager.searchResult = success.documents
                                            if success.meta.total == 0 {
                                                showNoResults = true
                                            }
                                            kakaoLocalManager.searchResult.forEach { value in
                                                let annotation = CustomAnnotation(placeInfo: value)
                                                annotations.append(annotation)
                                            }
                                        case .failure(let failure):
                                            showNetworkErrorAlert = true
                                            if failure.isSessionTaskError {
                                                showNetworkErrorAlertTitle = "네트워크 연결이 불안정합니다."
                                            } else {
                                                showNetworkErrorAlertTitle = "알 수 없는 에러입니다."
                                            }
                                        }
                                    } else {
                                        showNetworkErrorAlert = true
                                        showNetworkErrorAlertTitle = "네트워크 연결이 불안정합니다."
                                    }
                                }
                            }
                        }
                    }
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
        }
    }
}
