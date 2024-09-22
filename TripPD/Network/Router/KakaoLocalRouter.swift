//
//  KakaoLocalRouter.swift
//  TripPD
//
//  Created by 김상규 on 9/22/24.
//

import Foundation
import Alamofire

enum KakaoLocalRouter {
    case search(SearchQueryModel)
}

extension KakaoLocalRouter: TargetType {
    var baseURL: String {
        Header.baseURL.rawValue
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var header: [String : String] {
        switch self {
        case .search:
            [Header.authorization.rawValue: "\(Header.key.rawValue) \(APIKey.kakaoRestAPIKey)"]
        }
    }
    
    var path: String? {
        nil
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let searchQuery):
            [
                URLQueryItem(name: SearchField.sort.rawValue, value: searchQuery.sort.rawValue),
                URLQueryItem(name: SearchField.size.rawValue, value: "\(searchQuery.size)"),
                URLQueryItem(name: SearchField.page.rawValue, value: "\(searchQuery.page)"),
                URLQueryItem(name: SearchField.query.rawValue, value: searchQuery.query),
            ]
        }
    }
    
    private enum SearchField: String {
        case sort
        case size
        case page
        case query
    }
}
