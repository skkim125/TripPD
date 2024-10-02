//
//  Diary.swift
//  TripPD
//
//  Created by 김상규 on 9/17/24.
//

import Foundation
import RealmSwift

// MARK: 일기(추후 업데이트)
final class Diary: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String // 일기 제목
    @Persisted var content: String? // 일기 내용
    @Persisted var photos: RealmList<String> // 사진 모음
    
    convenience init(id: ObjectId, title: String, content: String? = nil, photos: RealmList<String>) {
        self.init()
        self.id = id
        self.title = title
        self.content = content
        self.photos = photos
    }
}
