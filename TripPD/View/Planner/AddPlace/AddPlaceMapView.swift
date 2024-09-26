//
//  AddPlaceMapView.swift
//  TripPD
//
//  Created by 김상규 on 9/23/24.
//

import SwiftUI
import MapKit
import BottomSheet
import PopupView
import RealmSwift

struct AddPlaceMapView: View {
    @ObservedRealmObject var schedule: Schedule
    @ObservedObject var kakaoLocalManager = KakaoLocalManager.shared
    @Binding var showMapView: Bool
    @State var offset: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var isSearched: Bool = false
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463), latitudinalMeters: 3000, longitudinalMeters: 3000)
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var annotations: [CustomAnnotation] = []
    @State private var showAlert = false
    @State private var sheetHeight: BottomSheetPosition = .relativeBottom(0.15)
    @State private var isSelected = false
    @State private var showPlaceWebView = false
    @State private var showAddPlacePopupView = false
    @State private var isSelectedPlace: PlaceInfo?
    @State private var placeURL = ""
    
    var body: some View {
        NavigationStack {
            MapView(annotations: $annotations, showAlert: $showAlert, isSearched: $isSearched, isSelected: $isSelected, type: .addPlace) { place in
                placeURL = place.placeURL
                isSelectedPlace = place
                showPlaceWebView = true
            }
            .bottomSheet(bottomSheetPosition: $sheetHeight, switchablePositions: [.relativeBottom(0.15), .absolute(365), .relativeTop(0.78)], headerContent: {
                SearchListHeaderView(annotations: $annotations, sheetHeight: $sheetHeight, isSelected: $isSelected, isSearched: $isSearched)
            }){
                if isSelected && showPlaceWebView {
                        VStack {
                            HStack {
                                
                                Spacer()
                                
                                Button {
                                    if let place = isSelectedPlace {
                                        print(place.placeName)
                                        showAddPlacePopupView.toggle()
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                .tint(.mainApp)
                            }
                            .frame(height: 30)
                            .padding(.top, 8)
                            .padding(.trailing, 28)
                            
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
            .interactiveDismissDisabled(showAddPlacePopupView)
            .popup(isPresented: $showAddPlacePopupView) {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.mainApp.gradient, lineWidth: 2)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        if let place = isSelectedPlace {
                            VStack {
                                HStack(alignment: .center) {
                                    Button {
                                        showAddPlacePopupView.toggle()
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                    }
                                    .tint(.gray)
                                    .frame(alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Button {
                                        let lat = Double(place.lat) ?? 0.0
                                        let lon = Double(place.lon) ?? 0.0
                                        TravelManager.shared.addPlace(schedule: schedule, time: Date(), name: place.placeName, lat: lat, lon: lon)
                                        showAddPlacePopupView.toggle()
                                    } label: {
                                        Text("추가")
                                            .foregroundStyle(.mainApp)
                                            .font(.appFont(25))
                                    }
                                    .tint(.gray)
                                    .frame(alignment: .trailing)
                                }
                                .padding()
                                
                                Spacer()
                                
                                Text("\(place.placeName)")
                                    .foregroundStyle(Color(uiColor: .label).gradient)
                                    .font(.appFont(20))
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 500)
                    .padding()
                
            } customize: {
                $0
                    .closeOnTap(false)
                    .closeOnTapOutside(false)
                    .type(.floater(verticalPadding: UIScreen.main.bounds.height / 5.5, horizontalPadding: 20, useSafeAreaInset: false))
                    .position(.bottom)
                    .dragToDismiss(false)
                    .backgroundView {
                        Color.black.opacity(0.3)
                    }
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
                        sheetHeight = .relativeBottom(0.15)
                    }
                }
            }
            .onDisappear {
                kakaoLocalManager.searchResult.removeAll()
                KeyboardNotificationManager.shared.removeNotiObserver()
            }
            .onChange(of: isSelectedPlace) { _ in
                sheetHeight = .relativeTop(0.78)
                showPlaceWebView = true
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
