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
    @State private var annotations: [CustomAnnotation] = []
    @State private var showAlert = false
    @State private var sheetHeight: BottomSheetPosition = .relative(0.18)
    @State private var isSelected = false
    @State private var showPlaceWebView = false
    @State private var isSelectedPlace: PlaceInfo?
    @State private var placeURL = ""
    
    var body: some View {
        NavigationStack {
            MapView(annotations: $annotations, showAlert: $showAlert, isSearched: $isSearched, isSelected: $isSelected, type: .addPlace) { place in
                placeURL = place.placeURL
                isSelectedPlace = place
                showPlaceWebView = true
            }
            .bottomSheet(bottomSheetPosition: $sheetHeight, switchablePositions: [.relative(0.18), .absolute(365), .relativeTop(0.78)], headerContent: {
                SearchListHeaderView(annotations: $annotations, sheetHeight: $sheetHeight, isSelected: $isSelected, isSearched: $isSearched)
            }){
                if showPlaceWebView {
                    VStack {
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                if let place = isSelectedPlace {
                                    print(place.placeName)
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.trailing, 15)
                        
                        PlaceInfoWebView(urlString: placeURL)
                            .onChange(of: placeURL) { newURL in
                                showPlaceWebView = !newURL.isEmpty
                            }
                    }
                }
            }
            .showDragIndicator(false)
            .enableAccountingForKeyboardHeight(true)
            .customBackground {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.ultraThinMaterial)
            }
            .onAppear {
                KeyboardNotificationManager.shared.keyboardNoti { _ in
                    if sheetHeight == .relativeTop(0.78) {
                        sheetHeight = .relativeTop(0.78)
                    } else if sheetHeight == .relativeTop(0.78) &&  kakaoLocalManager.searchResult.isEmpty {
                        sheetHeight = .absolute(365)
                    } else {
                        sheetHeight = .absolute(365)
                    }
                } hideHandler: { _ in
                    if sheetHeight == .relativeTop(0.78) {
                        sheetHeight = .relativeTop(0.78)
                    } else {
                        sheetHeight = .relative(0.18)
                    }
                }
            }
            .onDisappear {
                kakaoLocalManager.searchResult.removeAll()
                KeyboardNotificationManager.shared.removeNotiObserver()
            }
            .onChange(of: isSelected) { newValue in
                if newValue {
                    sheetHeight = .relativeTop(0.78)
                }
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
