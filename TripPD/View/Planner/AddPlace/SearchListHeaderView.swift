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
                
                TextField("검색", text: $viewModel.input.query)
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
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
        }
    }
}
