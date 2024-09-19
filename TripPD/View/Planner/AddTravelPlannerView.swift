//
//  AddTravelPlannerView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import PhotosUI

struct AddTravelPlannerView: View {
    @ObservedObject var travelManager: TravelManager
    
    @Binding var showSheet: Bool
    @State private var title = ""
    @State private var travelConcept = ""
    @State private var image: Data?
    @State private var dates: [Date] = []
    @State private var showDatePickerView = false
    @State private var showPHPickeView = false
    @FocusState var isFocused: Bool
    
    var isFilled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !dates.isEmpty
    }
    
    var dateText: String {
        if let firstDay = dates.first, let lastDay = dates.last {
            let first = firstDay.customDateFormatter(.coverView)
            let last = lastDay.customDateFormatter(.coverView)
            
            return "\(first) ~ \(last)"
        } else {
            return ""
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    plannerSettingView(.photo)
                        .padding(.top, 15)
                    
                    plannerSettingView(.title)
                        .padding(.top, 20)
                        .focused($isFocused)
                        .id("title")
                    
                    plannerSettingView(.date)
                        .padding(.top, 20)
                    
                    plannerSettingView(.concept)
                        .padding(.top, 20)
                        .focused($isFocused)
                        .id("concept")
                        .onChange(of: travelConcept) { _ in
                            if travelConcept.last?.isNewline == true {
                                travelConcept.removeLast()
                                isFocused = false
                            }
                        }
                        .onTapGesture {
                            
                        }
                }
                .scrollDismissesKeyboard(.automatic)
                .onChange(of: isFocused, perform: { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                        withAnimation {
                            proxy.scrollTo("concept", anchor: .center)
                        }
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.red.gradient)
                            .font(.appFont(18))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let url = ImageManager.shared.saveImage(imageData: image)
                        
                        travelManager.addTravelPlanner(date: Date(), title: title, travelConcept: travelConcept, travelDate: dates, coverImageURL: url)
                        
                        print("추가 완료")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showSheet.toggle()
                        }
                    } label: {
                        Text("추가")
                            .foregroundStyle(isFilled ? (Color.mainApp.gradient) : Color.gray.gradient).bold()
                            .font(.appFont(18))
                    }
                    .disabled(!isFilled)
                }
            }
            .navigationBarTitle(.mainApp, 20)
            .navigationTitle("여행 플랜 생성하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

// MARK: ViewBuilder
extension AddTravelPlannerView {
    @ViewBuilder
    func plannerSettingView(_ type: SettingPlan) -> some View {
        switch type {
        case .title:
            VStack {
                AddPlannerElementTitleView(type: .title)
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.mainApp.gradient)
                    .foregroundStyle(.bar)
                    .overlay {
                        ZStack {
                            TextField(type.descript, text: $title)
                                .textFieldStyle(.plain)
                                .padding(.horizontal, 10)
                                .font(.appFont(15))
                                .submitLabel(.done)
                                .onChange(of: title) { _ in
                                    if title.count > 10 {
                                        title = String(title.prefix(10))
                                    }
                                }
                            
                            Text("(\(title.count) / 10)")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 10))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .frame(height: 40)
            }
            .padding(.horizontal, 20)
            
        case .date:
            VStack {
                AddPlannerElementTitleView(type: .date)
                
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.mainApp.gradient)
                        .foregroundStyle(.bar)
                        .overlay {
                            HStack {
                                Text(dates.isEmpty ? type.descript : dateText)
                                    .foregroundStyle(dates.isEmpty ? .gray.opacity(0.5) : .mainApp)
                                    .padding(.horizontal, 10)
                                    .font(.appFont(15))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 40)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            showDatePickerView.toggle()
                        }
                    
                    Button {
                        showDatePickerView.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                    }
                    .frame(width: 35, height: 35)
                    .tint(.mainApp)
                    .sheet(isPresented: $showDatePickerView) {
                        CustomCalendarView(selectedDates: $dates, showDatePickerView: $showDatePickerView)
                            .presentationDetents([.medium])
                            .padding(.bottom, 10)
                    }
                }
            }
            .padding(.horizontal, 20)
            
        case .concept:
            VStack {
                AddPlannerElementTitleView(type: .concept)
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.mainApp.gradient)
                    .foregroundStyle(.bar)
                    .overlay {
                        ZStack {
                            TextEditor(text: $travelConcept)
                                .font(.appFont(15))
                                .submitLabel(.done)
                                .padding(.init(top: 6, leading: 6, bottom: 5, trailing: 6))
                                .onChange(of: travelConcept) { _ in
                                    if travelConcept.count > 45 {
                                        travelConcept = String(travelConcept.prefix(45))
                                    }
                                }
                            
                            VStack {
                                Text(type.descript)
                                    .foregroundStyle(Color(uiColor: .placeholderText))
                                    .font(.appFont(15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 15)
                                    .padding(.leading, 11)
                                    .opacity(travelConcept.isEmpty ? 1: 0)
                                
                                Spacer()
                                
                                Text("(\(travelConcept.count) / 45)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                                    .padding(.init(top: 0, leading: 0, bottom: 10, trailing: 10))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                    .frame(height: 100)
            }
            .padding(.horizontal, 20)
            
        case .photo:
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    AddPlannerElementTitleView(type: .photo)
                    
                    Text(type.descript)
                        .font(.appFont(12))
                        .foregroundStyle(.mainApp)
                        .padding(.leading, -5)
                    
                    Spacer()
                }
                
                HStack {
                    Button {
                        showPHPickeView.toggle()
                    } label: {
                        TravelCoverView(title: $title, dates: $dates, image: $image, isStar: .constant(false))
                    }
                    .shadow(color: .gray.opacity(0.3), radius: 7)
                    .sheet(isPresented: $showPHPickeView) {
                        AddPhotoView(showPHPickeView: $showPHPickeView) { image in
                            self.image = image
                        }
                        .ignoresSafeArea(.container, edges: .bottom)
                    }
                }
                .padding(.top, 5)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AddTravelPlannerView(travelManager: TravelManager.shared, showSheet: .constant(true))
}
