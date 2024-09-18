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
    
    var isFilled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !dates.isEmpty
    }
    
    var dateText: String {
        if let firstDay = dates.first, let lastDay = dates.last {
            let first = DateFormatter.customDateFormatter(date: firstDay, .coverView)
            let last = DateFormatter.customDateFormatter(date: lastDay, .coverView)
            
            return "\(first) ~ \(last)"
        } else {
            return ""
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    
                    plannerSettingView(.photo)
                        .padding(.top, 15)
                    
                    plannerSettingView(.title)
                    
                    plannerSettingView(.date)
                        .padding(.top, 5)
                    
                    plannerSettingView(.concept)
                        .padding(.top, 5)
                    
                    Spacer()
                }
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
                        TextField(type.descript, text: $title)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 10)
                            .font(.appFont(15))
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
                                .padding(.all, 6)
                            
                            VStack {
                                Text(type.descript)
                                    .foregroundStyle(.gray.opacity(0.5))
                                    .font(.appFont(15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 15)
                                    .padding(.leading, 15)
                                
                                Spacer()
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
                        TravelCoverView(title: $title, dates: $dates, image: $image)
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
