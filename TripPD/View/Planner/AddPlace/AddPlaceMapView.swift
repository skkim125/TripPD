//
//  AddPlaceMapView.swift
//  TripPD
//
//  Created by 김상규 on 9/23/24.
//

import SwiftUI
import MapKit
import BottomSheet

struct AddPlaceMapView: View {
    @ObservedObject var kakaoLocalManager = KakaoLocalManager.shared
    @Binding var showMapView: Bool
    @State var offset: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var isSearched: Bool = false
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463), latitudinalMeters: 3000, longitudinalMeters: 3000)
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var annotations: [MKPointAnnotation] = []
    @State private var showAlert = false
    @State private var detentsOption: PresentationDetent = PresentationDetent.height(200)
    @State private var sheetHeight: BottomSheetPosition = .relative(0.15)
    @State private var isSelected = false
    
    var body: some View {
        NavigationStack {
            MapView(annotations: $annotations, showAlert: $showAlert, isSelected: $isSelected, type: .addPlace)
                .bottomSheet(bottomSheetPosition: $sheetHeight, switchablePositions: [.relative(0.1), .relative(0.55), .relativeTop(0.9)], headerContent: {
                    SearchListHeaderView(sheetHeight: $sheetHeight, isSelected: $isSelected)
                }){
                    SearchListView(sheetHeight: $sheetHeight, annotations: $annotations, isSelected: $isSelected)
                }
                .showDragIndicator(false)
                .customBackground {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.ultraThinMaterial)
                }
                .onAppear {
                    KeyboardNotificationManager.shared.keyboardNoti { _ in
                        if sheetHeight == .relativeTop(0.9) {
                            sheetHeight = .relativeTop(0.9)
                        } else {
                            sheetHeight = .relative(0.55)
                        }
                    } hideHandler: { _ in
                        if sheetHeight == .relativeTop(0.9) {
                            sheetHeight = .relativeTop(0.9)
                        } else {
                            sheetHeight = .relative(0.1)
                        }
                    }
                }
                .onDisappear {
                    kakaoLocalManager.searchResult.removeAll()
                    KeyboardNotificationManager.shared.removeNotiObserver()
                }
                
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showMapView.toggle()
                        } label: {
                            Text("닫기")
                        }
                    }
                }
                .navigationTitle("장소 추가")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle(20, 30)
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func convertToMapCoordinate(location: CGPoint, mapSize: CGSize) -> CLLocationCoordinate2D {
        let mapCenter = mapRegion.center
        let span = mapRegion.span
        
        let longitude = mapCenter.longitude + (Double(location.x / mapSize.width) - 0.5) * span.longitudeDelta
        let latitude = mapCenter.latitude - (Double(location.y / mapSize.height) - 0.5) * span.latitudeDelta
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
