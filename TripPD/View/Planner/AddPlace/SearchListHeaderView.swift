//
//  SearchListHeaderView.swift
//  TripPD
//
//  Created by 김상규 on 9/24/24.
//

import SwiftUI
import BottomSheet

struct SearchListHeaderView: View {
    @ObservedObject var viewModel: AddPlaceMapViewModel
    @Binding var sheetHeight: BottomSheetPosition
    @Binding var isSelected: Bool
    @Binding var isSearched: Bool
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundStyle(.gray.opacity(0.5))
                .padding(.top, 5)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.appFont(15))
                    .foregroundStyle(.gray)
                
                TextField("검색", text: $viewModel.input.query)
                    .focused($isSearchFieldFocused)
                    .keyboardType(.webSearch)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .onSubmit {
                        withAnimation {
                            isSelected = false
                            isSearched = true
                            sheetHeight = .dynamicBottom
                            viewModel.action(action: .search)
                        }
                    }
                    .onChange(of: isSearchFieldFocused) { focused in
//                        withAnimation {
                            if focused {
                                sheetHeight = .absolute(365)
                            } else {
                                sheetHeight = .relativeBottom(0.15)
                            }
//                        }
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
