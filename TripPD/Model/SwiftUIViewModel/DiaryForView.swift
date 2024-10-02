//
//  DiaryForView.swift
//  TripPD
//
//  Created by 김상규 on 10/2/24.
//

import Foundation

struct DiaryForView {
    var id = UUID().uuidString
    var title: String // 일기 제목
    var content: String? // 일기 내용
    var photos: [String] // 사진 모음
    
    init(id: String = UUID().uuidString, title: String, content: String? = nil, photos: [String]) {
        self.id = id
        self.title = title
        self.content = content
        self.photos = photos
    }
    
    init(diary: Diary) {
        self.id = diary.id.stringValue
        self.title = diary.title
        self.content = diary.content
        self.photos = diary.photos.map({ $0 })
    }
}
