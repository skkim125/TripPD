//
//  AddTravelPlannerView.swift
//  TripPD
//
//  Created by 김상규 on 9/13/24.
//

import SwiftUI
import PhotosUI

struct AddTravelPlannerView: View {
    @Binding var showSheet: Bool
    @State private var title = ""
    @State private var memo = ""
    @State private var image: UIImage?
    @State private var showPHPickeView = false
    
    var body: some View {
        NavigationStack {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.appBlack.gradient)
                            .font(.appFont(18))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Text("추가")
                            .foregroundStyle(.subColor2.gradient).bold()
                            .font(.appFont(18))
                    }
                }
            }
            .navigationBarTitleColor(.subColor2)
            .navigationTitle("여행 플랜 생성하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    func plannerSettingView(_ type: SettingPlan) -> some View {
        switch type {
        case .title:
            VStack {
                Text("\(type.rawValue)")
                    .foregroundStyle(.subColor2.gradient)
                    .font(.appFont(20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.subColor2.gradient)
                    .foregroundStyle(.bar)
                    .overlay {
                        TextField("제목을 입력해주세요", text: $title)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 10)
                            .font(.appFont(15))
                    }
                    .frame(height: 40)
            }
            .padding(.horizontal, 20)
            
        case .date:
            VStack {
                Text(type.rawValue)
                    .foregroundStyle(.subColor2.gradient)
                    .font(.appFont(20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.subColor2.gradient)
                        .foregroundStyle(.bar)
                        .overlay {
                            HStack {
                                Text("\(Date().formatted(date: .numeric, time: .standard))")
                                    .foregroundStyle(.subColor2)
                                    .padding(.horizontal, 10)
                                    .font(.appFont(15))
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 40)
                        .padding(.trailing, 10)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                    }
                    .frame(width: 35, height: 35)
                    .tint(.subColor2)
                }
            }
            .padding(.horizontal, 20)
            
        case .concept:
            VStack {
                Text(type.rawValue)
                    .foregroundStyle(.subColor2.gradient)
                    .font(.appFont(20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.subColor2.gradient)
                    .foregroundStyle(.bar)
                    .overlay {
                        ZStack {
                            TextEditor(text: $memo)
                                .font(.appFont(15))
                                .padding(.all, 6)
                            
                            VStack {
                                Text("여행 컨셉을 자유롭게 작성하세요!")
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
                    Text(type.rawValue)
                        .foregroundStyle(.subColor2.gradient)
                        .font(.appFont(20))
                        .padding(.leading, 5)
                    
                    Text("(커버 사진을 설정합니다)")
                        .font(.appFont(12))
                        .foregroundStyle(.subColor2)
                        .padding(.leading, -5)
                    
                    Spacer()
                }
                
                HStack {
                    Button {
                        showPHPickeView.toggle()
                    } label: {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .frame(height: 150)
                                .imageScale(.small)
                                .overlay {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(.ultraThinMaterial.opacity(0.7))
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, 5)
                            
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .background(.mainApp)
                                
                                Image(systemName: "airplane")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(.degrees(-20))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .frame(height: 250)
                                    .foregroundStyle(.mainApp.gradient.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.thinMaterial)
                        }
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
    
    enum SettingPlan: String {
        case title = "제목"
        case date = "여행 날짜"
        case concept = "컨셉"
        case photo = "플랜 커버"
    }
}

#Preview {
    AddTravelPlannerView(showSheet: .constant(true))
}
