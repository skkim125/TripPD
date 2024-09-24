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
    @Published var searchResult: [PlaceInfo] = []
    
    func searchPlace(sort: SearchSort, _ query: String, page: Int, completionHandler: @escaping (Result<SearchPlaceResponseModel, AFError>) -> Void) {
        
        let searchQuery = SearchQueryModel(sort: sort, query: query, page: page)
        
        do {
            let request = try KakaoLocalRouter.search(searchQuery).asURLRequest()
            
            AF.request(request).responseDecodable(of: SearchPlaceResponseModel.self) { response in
                    completionHandler(response.result)
            }
        } catch {
            print("asURLRequest 에러:", error)
        }
    }
    
}
