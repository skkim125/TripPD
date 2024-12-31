//
//  KakaoLocalManager.swift
//  TripPD
//
//  Created by 김상규 on 9/22/24.
//

import Foundation
import Alamofire

final class KakaoLocalManager: ObservableObject {
    static let shared = KakaoLocalManager()
    
    private init() { }
    
    func searchPlace(sort: SearchSort, _ query: String, page: Int) async throws -> SearchPlaceResponseModel {
        
        let searchQuery = SearchQueryModel(sort: sort, query: query, page: page)
        
        do {
            let request = try KakaoLocalRouter.search(searchQuery).asURLRequest()
            
            let dataTask = AF.request(request)
            let data = try await dataTask.serializingDecodable(SearchPlaceResponseModel.self).value
            
            return data
             
        } catch {
            throw error
        }
    }
}
