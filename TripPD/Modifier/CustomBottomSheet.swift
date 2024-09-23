//
//  CustomBottomSheet.swift
//  TripPD
//
//  Created by 김상규 on 9/22/24.
//

import SwiftUI

// available iOS 16.0
struct BottomSheet: View {
    private let kakaoLocalManager = KakaoLocalManager.shared
    @Binding var offset: CGFloat
    @Binding var isSearched: Bool
    var value: CGFloat
    
    @State private var query = ""
    @State private var page = 1
    @State private var sort: SearchSort = .accuracy
    @State private var searchResult: [PlaceInfo] = []
    
    var body: some View {
        VStack {
            
            Capsule()
                .fill(.gray.opacity(0.5))
                .frame(width: 50, height: 5)
                .padding(.top)
                .padding(.bottom, 5)
            
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.appFont(15))
                    .foregroundStyle(.gray)
                
                TextField("검색", text: $query)
                    .onSubmit {
                        withAnimation {
                            offset = value
                            isSearched = true
                            
                            DispatchQueue.main.async {
                                kakaoLocalManager.searchPlace(sort: sort, query, page: page) { result in
                                    switch result {
                                    case .success(let success):
                                        searchResult = success.documents
                                    case .failure(let failure):
                                        print(failure)
                                    }
                                }
                            }
                        }
                    }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(BlurView(style: .systemThinMaterial))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.horizontal, 20)
            
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(searchResult, id: \.self) { item in
                        HStack {
                            Text("\(item.categoryName)")
                            
                            Text("\(item.placeName)")
                        }
                        Divider()
                            .padding(.top, 10)
                    }
                }
                .padding()
                .padding(.top, 10)
            }
            .padding(.bottom, 50)
        }
        .background(BlurView(style: .systemUltraThinMaterial))
        .clipShape(.rect(cornerRadius: 30))
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIViewType(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

// available iOS 16.4
//extension View {
//
//    @ViewBuilder
//    func customBottomSheet<Content: View>(
//        height: Set<PresentationDetent>,
//        selection: Binding<PresentationDetent>,
//        isPresented: Binding<Bool>,
//        dragIndicator: Visibility = .visible,
//        sheetCornerRadius: CGFloat,
//        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
//        interactiveDisabled: Bool = true,
//        @ViewBuilder content: @escaping () -> Content,
//        onDismiss: @escaping () -> ()
//    ) -> some View {
//        self
//            .sheet(isPresented: isPresented) {
//                onDismiss()
//            } content: {
//                content()
//                    .presentationDetents(height, selection: selection)
//                    .presentationDragIndicator(dragIndicator)
//                    .interactiveDismissDisabled(interactiveDisabled)
//                    .clearModalBackground()
//                    .presentationBackgroundInteraction(.enabled)
//                    .presentationBackground(.ultraThinMaterial)
//                    .presentationCornerRadius(30)
//            }
//    }
//}
