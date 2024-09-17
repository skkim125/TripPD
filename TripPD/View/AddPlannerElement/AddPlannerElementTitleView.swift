//
//  AddPlannerElementTitleView.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import SwiftUI

struct AddPlannerElementTitleView: View {
    var type: SettingPlan
    
    var body: some View {
        Text(type.rawValue)
            .foregroundStyle(.mainApp.gradient)
            .font(.appFont(20))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 5)
    }
}

enum SettingPlan: String {
    case title = "제목"
    case date = "여행 날짜"
    case concept = "컨셉"
    case photo = "플랜 커버"
    
    var descript: String {
        switch self {
        case .title:
            "제목을 입력해주세요"
        case .date:
            "제목을 입력해주세요"
        case .concept:
            "여행 컨셉을 자유롭게 작성하세요!"
        case .photo:
            "(커버 사진을 설정합니다)"
        }
    }
}

#Preview {
    AddPlannerElementTitleView(type: .concept)
}
