//
//  SearchListView.swift
//  TripPD
//
//  Created by 김상규 on 9/24/24.
//

import SwiftUI
import MapKit
import BottomSheet

struct SearchListView: View {
    @ObservedObject var kakaoLocalManager = KakaoLocalManager.shared
    @Binding var sheetHeight: BottomSheetPosition
    @Binding var annotations: [MKPointAnnotation]
    @Binding var isSelected: Bool
    
    @State private var query = ""
    @State private var page = 1
    @State private var sort: SearchSort = .accuracy
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                ForEach(kakaoLocalManager.searchResult, id: \.self) { item in
                    Button {
                        if !annotations.isEmpty {
                            annotations.removeAll()
                        }
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(item.lat) ?? 0.0, longitude: Double(item.lon) ?? 0.0)
                        annotation.title = "\(item.placeName)"
                        annotations.append(annotation)
                        isSelected = true
                        sheetHeight = .relative(0.1)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(categoryString(item.categoryName))")
                                    .font(.appFont(12))
                                    .foregroundStyle(Color(uiColor: .darkGray))
                                
                                Text("\(item.placeName)")
                                    .font(.appFont(16))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                    }
                    .tint(Color(uiColor: .label))
                    
                    Divider()
                        .padding(.top, 10)
                }
                .padding(.horizontal, 10)
            }
        }
        .padding(.vertical, 10)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func categoryString(_ categoryName: String) -> String {
        if let greaterThanIndex = categoryName.lastIndex(of: ">") {
            let firstI = categoryName.index(after: greaterThanIndex)
            let lastI = categoryName.index(before: categoryName.endIndex)
            return String(categoryName[firstI...lastI])
        } else {
            return categoryName
        }
    }
}
