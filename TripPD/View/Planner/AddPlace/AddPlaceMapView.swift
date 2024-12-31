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
    @StateObject var viewModel: AddPlaceMapViewModel
    @Binding var showMapView: Bool
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463), latitudinalMeters: 3000, longitudinalMeters: 3000)
    @State private var sheetHeight: BottomSheetPosition = .relativeBottom(0.15)
    @State private var isSearched: Bool = false
    @State private var showAlert = false
    @State private var isSelected = false
    @State private var showAddPlacePopupView = false
    
    init(schedule: ScheduleForView, showMapView: Binding<Bool>) {
        self._showMapView = showMapView
        self._viewModel = StateObject(wrappedValue: AddPlaceMapViewModel(schedule: schedule))
    }
    
    var body: some View {
        NavigationStack {
            MapView(annotations: $viewModel.output.annotations, showAlert: $showAlert, isSearched: $isSearched, isSelected: $isSelected) { place in
                
                viewModel.action(action: .selectPlace(place))
                sheetHeight = .relativeTop(0.78)
            }
            .bottomSheet(bottomSheetPosition: $sheetHeight, switchablePositions: [.relativeBottom(0.15), .absolute(365), .relativeTop(0.78)], headerContent: {
                SearchListHeaderView(viewModel: viewModel, sheetHeight: $sheetHeight, isSelected: $isSelected, isSearched: $isSearched)
            }){
                if isSelected {
                    if viewModel.networkMonitor.isConnected {
                        VStack {
                            HStack {
                                
                                Spacer()
                                
                                Button {
                                    showAddPlacePopupView = true
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
                            
                            PlaceInfoWebView(urlString: viewModel.output.placeURL)
                        }
                    } else {
                        VStack(spacing: 15) {
                            Text("네트워크 연결이 되어있지 않습니다")
                                .font(.appFont(15))
                            
                            Text("네트워크 연결 후 다시 시도해주세요")
                                .font(.appFont(12))
                            
                            Button {
                                viewModel.networkMonitor.checkConnect()
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
            .popup(isPresented: $viewModel.output.showNoResult) {
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
            .onChange(of: viewModel.networkMonitor.isConnected) { value in
                if !value {
                    viewModel.output.showErrorAlert = true
                    viewModel.output.showErrorAlertTitle = "네트워크가 연결되어있지 않습니다."
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("위치 권한 필요"),
                    message: Text("위치 권한이 필요합니다. 설정에서 권한을 허용해주세요."),
                    primaryButton: .default(Text("설정으로 이동"), action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            Task {
                                await UIApplication.shared.open(url)
                            }
                        }
                    }),
                    secondaryButton: .cancel(Text("닫기"))
                )
            }
            .alert(viewModel.output.showErrorAlertTitle, isPresented: $viewModel.output.showErrorAlert, actions: {
                Button("확인") {
                    viewModel.output.showErrorAlert.toggle()
                }
            }, message: {
                Text("잠시 후 다시 시도해주세요")
            })
            .onAppear {
                KeyboardNotificationManager.shared.keyboardNoti { _ in
                    if sheetHeight == .relativeTop(0.78) {
                        sheetHeight = .relativeTop(0.78)
                    } else if sheetHeight == .relativeTop(0.78) &&  viewModel.output.annotations.isEmpty {
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
                KeyboardNotificationManager.shared.removeNotiObserver()
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
                    PlaceFormView(schedule: $viewModel.output.schedule, isSelectedPlace: $viewModel.output.isSelectedPlace, showAddPlacePopupView: $showAddPlacePopupView, viewType: .add)
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
