//
//  AddPlaceView.swift
//  TripPD
//
//  Created by 김상규 on 10/3/24.
//

import SwiftUI

struct AddPlaceView: View {
    var travelManager = TravelManager.shared
    var schedule: ScheduleForView
    @Binding var isSelectedPlace: PlaceForView?
    @Binding var showAddPlacePopupView: Bool
    
    @State private var placeURL = ""
    @State private var travelTime = Date()
    @State private var placeMemo = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
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
                    
                    Text("\(place.name)")
                        .foregroundStyle(Color(uiColor: .label).gradient)
                        .font(.appFont(20))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button {
                        travelManager.addPlace(schedule: schedule, time: travelTime, name: place.name, address: place.address, placeMemo: placeMemo, lat: place.lat, lon: place.lon)
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
                
                Text("\(place.name)")
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
}

//#Preview {
//    AddPlaceView()
//}
