//
//  TargetType.swift
//  TripPD
//
//  Created by 김상규 on 9/22/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String? { get }
    var header: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = try URLRequest(url: url, method: method)
        request.allHTTPHeaderFields = header
        request.url?.append(queryItems: queryItems ?? [])
        request.timeoutInterval = 5
        
        return request
    }
}
