//
//  AddTravelPlannerView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import PhotosUI

struct AddTravelPlannerView: View {
    @ObservedObject var viewModel: AddTravelPlannerViewModel
    @FocusState var isFocused: Bool
    @Binding var showSheet: Bool
    @Binding var showToast: Bool

    init(showSheet: Binding<Bool>, showToast: Binding<Bool>) {
        self.viewModel = AddTravelPlannerViewModel()
        self._showSheet = showSheet
        self._showToast = showToast
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
                        .onChange(of: viewModel.travelConcept) { value in
                            if value.last?.isNewline == true {
                                viewModel.travelConcept.removeLast()
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
                        DispatchQueue.main.async {
                            viewModel.action(action: .addButtonAction)
                            showSheet.toggle()
                            showToast.toggle()
                        }
                    } label: {
                        Text("추가")
                            .foregroundStyle(viewModel.isFilled ? (Color.mainApp.gradient) : Color.gray.gradient).bold()
                            .font(.appFont(16))
                    }
                    .disabled(!viewModel.isFilled)
                }
            }
            .navigationBarTitle(20, 30)
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
                            TextField(type.descript, text: $viewModel.title)
                                .textFieldStyle(.plain)
                                .padding(.horizontal, 10)
                                .font(.appFont(14))
                                .submitLabel(.done)
                                .onChange(of: viewModel.title) { value in
                                    if value.count > 10 {
                                        viewModel.title = String(value.prefix(10))
                                    }
                                }
                            
                            Text("(\(viewModel.title.count) / 10)")
                                .font(.system(size: 13))
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
                                Text(viewModel.dates.isEmpty ? type.descript : viewModel.dateText)
                                    .foregroundStyle(viewModel.dates.isEmpty ? .gray.opacity(0.5) : .mainApp)
                                    .padding(.horizontal, 10)
                                    .font(.appFont(14))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 40)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            viewModel.action(action: .showDatePickerView)
                        }
                    
                    Button {
                        viewModel.action(action: .showDatePickerView)
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                    }
                    .frame(width: 35, height: 35)
                    .tint(.mainApp)
                    .sheet(isPresented: $viewModel.showDatePickerView) {
                        CustomCalendarView(selectedDates: $viewModel.dates, showDatePickerView: $viewModel.showDatePickerView)
                            .presentationDetents([.medium])
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
                            TextEditor(text: $viewModel.travelConcept)
                                .font(.appFont(14))
                                .submitLabel(.done)
                                .padding(.init(top: 6, leading: 6, bottom: 5, trailing: 6))
                                .onChange(of: viewModel.travelConcept) { value in
                                    if value.count > 45 {
                                        viewModel.travelConcept = String(value.prefix(45))
                                    }
                                }
                            
                            VStack {
                                Text(type.descript)
                                    .foregroundStyle(Color(uiColor: .placeholderText))
                                    .font(.appFont(14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 15)
                                    .padding(.leading, 11)
                                    .opacity(viewModel.travelConcept.isEmpty ? 1: 0)
                                
                                Spacer()
                                
                                Text("(\(viewModel.travelConcept.count) / 45)")
                                    .font(.system(size: 13))
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
                        viewModel.action(action: .showPHPickeView)
                    } label: {
                        TravelCoverView(title: $viewModel.title, dates: $viewModel.dates, image: $viewModel.image, isStar: .constant(false))
                    }
                    .shadow(color: .gray.opacity(0.3), radius: 7)
                    .sheet(isPresented: $viewModel.showPHPickeView) {
                        AddPhotoView(showPHPickeView: $viewModel.showPHPickeView) { image in
                            viewModel.image = image
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

//#Preview {
//    AddTravelPlannerView(viewModel: CustomTabBarViewModel())
//}
