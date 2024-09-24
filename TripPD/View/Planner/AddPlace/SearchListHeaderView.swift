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
    
    @Binding var sheetHeight: BottomSheetPosition
    @Binding var isSelected: Bool
    
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
                    .keyboardType(.default)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit {
                        withAnimation {
                            isSelected = false
                            sheetHeight = .relativeTop(0.9)
                            DispatchQueue.main.async {
                                kakaoLocalManager.searchPlace(sort: sort, query, page: page) { result in
                                    switch result {
                                    case .success(let success):
                                        kakaoLocalManager.searchResult = success.documents
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
