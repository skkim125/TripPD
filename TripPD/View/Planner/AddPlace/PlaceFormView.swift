//
//  PlaceFormView.swift
//  TripPD
//
//  Created by 김상규 on 10/3/24.
//

import SwiftUI

struct PlaceFormView: View {
    var travelManager = TravelManager.shared
    var viewType: PlaceViewType
    @Binding var schedule: ScheduleForView
    @Binding var isSelectedPlace: PlaceForView
    @Binding var showAddPlacePopupView: Bool
    @Binding var setRegion: Bool
    @State private var travelTime: Date = Date()
    @State private var placeMemo: String = ""
    @FocusState var isFocused: Bool
    
    init(schedule: Binding<ScheduleForView>, isSelectedPlace: Binding<PlaceForView>, showAddPlacePopupView: Binding<Bool>, setRegion: Binding<Bool>, viewType: PlaceViewType) {
        self._schedule = schedule
        self._isSelectedPlace = isSelectedPlace
        self._showAddPlacePopupView = showAddPlacePopupView
        self._setRegion = setRegion
        self.viewType = viewType
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button {
                    showAddPlacePopupView.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }
                .tint(.gray)
                .frame(alignment: .leading)
                
                Spacer()
                
                Text("\(isSelectedPlace.name)")
                    .foregroundStyle(Color(uiColor: .label).gradient)
                    .font(.appFont(20))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    switch viewType {
                    case .add:
                        travelManager.addPlace(schedule: schedule, time: travelTime, name: isSelectedPlace.name, address: isSelectedPlace.address, placeMemo: placeMemo, lat: isSelectedPlace.lat, lon: isSelectedPlace.lon)
                    case .edit:
                        travelManager.updatePlace(placeId: isSelectedPlace.id, time: travelTime, name: isSelectedPlace.name, address: isSelectedPlace.address, placeMemo: placeMemo, lat: isSelectedPlace.lat, lon: isSelectedPlace.lon, isStar: false)
                    }
                    
                    self.setRegion = true
                    showAddPlacePopupView.toggle()
                } label: {
                    Text(viewType.buttonText)
                        .foregroundStyle(.mainApp)
                        .font(.appFont(20))
                }
                .tint(.gray)
                .frame(alignment: .trailing)
            }
            .padding(15)
            .padding(.horizontal, 10)
            
            Spacer()
            
            Text("\(isSelectedPlace.address)")
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
        .onAppear {
            travelTime = isSelectedPlace.time
            placeMemo = isSelectedPlace.placeMemo ?? ""
        }
    }
}

enum PlaceViewType {
    case add
    case edit
    
    var buttonText: String {
        switch self {
        case .add:
            "추가"
        case .edit:
            "수정"
        }
    }
}
