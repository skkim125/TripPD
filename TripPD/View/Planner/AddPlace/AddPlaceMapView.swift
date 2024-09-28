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
    @FocusState var isFocused: Bool
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
    @State private var showNoResults = false
    @State private var isSelectedPlace: PlaceInfo?
    @State private var placeURL = ""
    @State private var travelTime = Date()
    @State private var placeMemo = ""
    
    var body: some View {
        NavigationStack {
            MapView(annotations: $annotations, showAlert: $showAlert, isSearched: $isSearched, isSelected: $isSelected, type: .addPlace) { place in
                placeURL = place.placeURL
                isSelectedPlace = place
                showPlaceWebView = true
            }
            .bottomSheet(bottomSheetPosition: $sheetHeight, switchablePositions: [.relativeBottom(0.15), .absolute(365), .relativeTop(0.78)], headerContent: {
                SearchListHeaderView(annotations: $annotations, sheetHeight: $sheetHeight, isSelected: $isSelected, isSearched: $isSearched, showNoResults: $showNoResults)
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
            .popup(isPresented: $showNoResults) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.mainApp.gradient, lineWidth: 2)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        Text("검색 결과가 없습니다.")
                            .foregroundStyle(Color(uiColor: .label).gradient)
                            .font(.appFont(14))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 250, height: 50)
                    .padding(.bottom, 100)
            } customize: {
                $0
                    .autohideIn(2)
                    .closeOnTap(true)
                    .closeOnTapOutside(true)
                    .type(.toast)
                    .position(.bottom)
            }
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
                                            .frame(width: 25)
                                    }
                                    .tint(.gray)
                                    .frame(alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Text("\(place.placeName)")
                                        .foregroundStyle(Color(uiColor: .label).gradient)
                                        .font(.appFont(20))
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                    
                                    Button {
                                        let lat = Double(place.lat) ?? 0.0
                                        let lon = Double(place.lon) ?? 0.0
                                        TravelManager.shared.addPlace(schedule: schedule, time: travelTime, name: place.placeName, address: place.roadAddress, placeMemo: placeMemo , lat: lat, lon: lon)
                                        showAddPlacePopupView.toggle()
                                    } label: {
                                        Text("추가")
                                            .foregroundStyle(.mainApp)
                                            .font(.appFont(20))
                                    }
                                    .tint(.gray)
                                    .frame(alignment: .trailing)
                                }
                                .padding()
                                .padding(.horizontal, 10)
                                
                                Spacer()
                                
                                Text("\(place.roadAddress)")
                                    .foregroundStyle(Color(uiColor: .label).gradient)
                                    .font(.appFont(14))
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 50)
                                
                                HStack(alignment: .center) {
                                    Text("여행 시간")
                                        .font(.appFont(16))
                                    
                                    DatePicker("", selection: $travelTime, in: schedule.day...,displayedComponents: .hourAndMinute)
                                        .padding()
                                        .datePickerStyle(.wheel)
                                        .frame(height: 50)
                                        .padding()
                                        .labelsHidden()
                                }
                                .padding(.vertical, 5)
                                
                                VStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.mainApp.gradient)
                                        .foregroundStyle(.bar)
                                        .overlay {
                                            ZStack {
                                                TextEditor(text: $placeMemo)
                                                    .font(.appFont(14))
                                                    .submitLabel(.done)
                                                    .padding(.init(top: 0, leading: 6, bottom: 0, trailing: 6))
                                                    .onChange(of: placeMemo) { _ in
                                                        if placeMemo.count > 30 {
                                                            placeMemo = String(placeMemo.prefix(30))
                                                        }
                                                        
                                                        if placeMemo.last?.isNewline == true {
                                                            placeMemo.removeLast()
                                                            isFocused = false
                                                        }
                                                    }
                                                    .frame(height: 50)
                                                
                                                VStack {
                                                    Text("메모 하기")
                                                        .foregroundStyle(Color(uiColor: .placeholderText))
                                                        .font(.appFont(14))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.top, 15)
                                                        .padding(.leading, 11)
                                                        .opacity(placeMemo.isEmpty ? 1: 0)
                                                    
                                                    Spacer()
                                                    
                                                    Text("(\(placeMemo.count) / 45)")
                                                        .font(.system(size: 13))
                                                        .foregroundStyle(.gray)
                                                        .padding(.init(top: 0, leading: 0, bottom: 10, trailing: 10))
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                }
                                            }
                                        }
                                        .frame(height: 60)
                                        .focused($isFocused)
                                        .id("memo")
                                }
                                .padding(.all, 10)
                                .padding(.top, 30)
                                .padding(.bottom, 10)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 350)
                    .padding()
                
            } customize: {
                $0
                    .closeOnTap(false)
                    .closeOnTapOutside(false)
                    .type(.floater(verticalPadding: 10, horizontalPadding: 20, useSafeAreaInset: true))
                    .position(.bottom)
                    .dragToDismiss(false)
                    .useKeyboardSafeArea(true)
                    .backgroundView {
                        Color.black.opacity(0.3)
                    }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("위치 권한 필요"),
                    message: Text("위치 권한이 필요합니다. 설정에서 권한을 허용해주세요."),
                    primaryButton: .default(Text("설정으로 이동"), action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            DispatchQueue.main.async {
                                UIApplication.shared.open(url)
                            }
                        }
                    }),
                    secondaryButton: .cancel(Text("닫기"))
                )
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
                travelTime = schedule.day
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
                            .font(.appFont(16))
                    }
                    .tint(.appBlack)
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
