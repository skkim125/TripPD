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
    var schedule: ScheduleForView
    private let networkMonitor = NetworkMonitor.shared
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
    @State private var showNoResults = false
    @State private var isSelectedPlace: PlaceForView?
    @State private var placeURL = ""
    @State private var travelTime = Date()
    @State private var placeMemo = ""
    @State private var showNetworkErrorAlert = false
    @State private var showNetworkErrorAlertTitle = ""
    @State private var time = Date()
    
    init(schedule: ScheduleForView, showMapView: Binding<Bool>) {
        self.schedule = schedule
        self._showMapView = showMapView
    }
    
    var body: some View {
        NavigationStack {
            MapView(annotations: $annotations, showAlert: $showAlert, isSearched: $isSearched, isSelected: $isSelected, type: .addPlace) { place in
                placeURL = place.placeURL
                let lat = Double(place.lat) ?? 0.0
                let lon = Double(place.lon) ?? 0.0
                
                isSelectedPlace = PlaceForView(time: Date(), name: place.placeName, address: place.roadAddress, lat: lat, lon: lon, isStar: false)
                time = isSelectedPlace?.time ?? Date()
                showPlaceWebView = true
            }
            .bottomSheet(bottomSheetPosition: $sheetHeight, switchablePositions: [.relativeBottom(0.15), .absolute(365), .relativeTop(0.78)], headerContent: {
                SearchListHeaderView(annotations: $annotations, sheetHeight: $sheetHeight, isSelected: $isSelected, isSearched: $isSearched, showNoResults: $showNoResults, showNetworkErrorAlert: $showNetworkErrorAlert, showNetworkErrorAlertTitle: $showNetworkErrorAlertTitle)
            }){
                if isSelected && showPlaceWebView {
                    if networkMonitor.isConnected {
                        VStack {
                            HStack {
                                
                                Spacer()
                                
                                Button {
                                    if let _ = isSelectedPlace {
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
                    } else {
                        VStack(spacing: 15) {
                            Text("네트워크 연결이 되어있지 않습니다")
                                .font(.appFont(15))
                            
                            Text("네트워크 연결 후 다시 시도해주세요")
                                .font(.appFont(12))
                            
                            Button {
                                networkMonitor.checkConnect()
                            } label: {
                                Image("arrow.clockwise.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            .frame(width: 20, height: 20)
                            .tint(.mainApp)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                        .onAppear {
                            sheetHeight = .absolute(365)
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
            .onChange(of: networkMonitor.isConnected) { value in
                if !value {
                    showNetworkErrorAlert = true
                    showNetworkErrorAlertTitle = "네트워크가 연결되어있지 않습니다."
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
            .alert(showNetworkErrorAlertTitle, isPresented: $showNetworkErrorAlert, actions: {
                Button("확인") {
                    showNetworkErrorAlert.toggle()
                }
            }, message: {
                Text("잠시 후 다시 시도해주세요")
            })
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
            .onChange(of: isSelectedPlace != nil) { _ in
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
        .popup(isPresented: $showAddPlacePopupView) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.mainApp.gradient, lineWidth: 2)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    AddPlaceView(schedule: schedule, isSelectedPlace: $isSelectedPlace, showAddPlacePopupView: $showAddPlacePopupView, travelTime: $time)
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
        .onTapGesture {
            hideKeyboard()
        }
    }
}
