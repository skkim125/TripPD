//
//  NetworkError.swift
//  TripPD
//
//  Created by 김상규 on 12/30/24.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case invalidRequest
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidServerConnect
    
    var errorDescription: String {
        switch self {
        case .unknown:
            return "알 수 없는 오류입니다."
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .invalidURL:
            return "URL이 올바르지 않습니다."
        case .invalidResponse:
            return "서버 응답이 유효하지 않습니다."
        case .invalidData:
            return "데이터가 유효하지 않습니다."
        case .invalidServerConnect:
            return "네트워크 연결이 불안정합니다."
        }
    }
}
