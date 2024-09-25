//
//  SearchListHeaderView.swift
//  TripPD
//
//  Created by 김상규 on 9/24/24.
//

import SwiftUI
import BottomSheet

struct SearchListHeaderView: View {
    @ObservedObject var kakaoLocalManager = KakaoLocalManager.shared
    
    @Binding var annotations: [CustomAnnotation]
    @Binding var sheetHeight: BottomSheetPosition
    @Binding var isSelected: Bool
    @Binding var isSearched: Bool
    
    @State private var query = ""
    @State private var page = 1
    @State private var sort: SearchSort = .accuracy
    
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
                                kakaoLocalManager.searchPlace(sort: sort, query, page: page) { result in
                                    switch result {
                                    case .success(let success):
                                        kakaoLocalManager.searchResult = success.documents
                                        kakaoLocalManager.searchResult.forEach { value in
                                            let annotation = CustomAnnotation(placeInfo: value)
                                            annotations.append(annotation)
                                        }
                                    case .failure(let failure):
                                        print(failure)
                                    }
                                }
                            }
                        }
                    }
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
        }
    }
}
