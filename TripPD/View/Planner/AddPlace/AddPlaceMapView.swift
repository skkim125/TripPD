//
//  AddPlaceMapView.swift
//  TripPD
//
//  Created by 김상규 on 9/23/24.
//

import SwiftUI
import MapKit

struct AddPlaceMapView: View {
    @Binding var showMapView: Bool
    @State var offset: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var isSearched: Bool = false
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.517742, longitude: 126.886463), latitudinalMeters: 3000, longitudinalMeters: 3000)
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var annotations: [MKPointAnnotation] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(annotations: $annotations, type: .addPlace)
                
                GeometryReader { geometry in
                    VStack {
                        BottomSheet(offset: $offset, isSearched: $isSearched, value: (-geometry.frame(in: .global).height + 150))
                            .offset(y: geometry.frame(in: .global).height - 70)
                            .offset(y: offset-keyboardHeight)
                            .gesture(DragGesture().onChanged({ value in
                                withAnimation {
                                    if value.startLocation.y > geometry.frame(in: .global).midX {
                                        
                                        if value.translation.height < 0 && offset > (-geometry.frame(in: .global).height + 150) {
                                            
                                            offset = value.translation.height
                                        }
                                    }
                                    
                                    if value.startLocation.y < geometry.frame(in: .global).midX {
                                        
                                        if value.translation.height > 0 && offset < 0 {
                                            
                                            offset = (-geometry.frame(in: .global).height + 150) + value.translation.height
                                        }
                                    }
                                }
                            }).onEnded({ value in
                                withAnimation {
                                    if value.startLocation.y > geometry.frame(in: .global).midX {
                                        
                                        if -value.translation.height > geometry.frame(in: .global).midX {
                                            
                                            offset = (-geometry.frame(in: .global).height + 150)
                                            
                                            return
                                        }
                                        offset = 0
                                    }
                                    
                                    if value.startLocation.y < geometry.frame(in: .global).midX {
                                        
                                        if value.translation.height < geometry.frame(in: .global).midX {
                                            
                                            offset = (-geometry.frame(in: .global).height + 150)
                                            
                                            return
                                        } else {
                                            isSearched = false
                                        }
                                        
                                        offset = 0
                                    }
                                }
                            }))
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
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
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                KeyboardNotificationManager.shared.keyboardNoti { value in
                    withAnimation {
                        if !isSearched {
                            keyboardHeight = value
                        }
                    }
                } hideHandler: { _ in
                    withAnimation {
                        keyboardHeight = 0
                    }
                }
            }
            .onDisappear {
                KeyboardNotificationManager.shared.removeNotiObserver()
            }
        }
    }
}
