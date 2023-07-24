//
//  HomeViewModel.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/07/17.
//

import Foundation
import Alamofire
import SwiftyJSON
import NMapsMap

class KakaoAPIViewModel {
    
    var resultList: [Document]?
    
    var infoWindows: [NMFInfoWindow]?
    
    func findPlaceWithKeyword(x: String, y: String, radius: Int, page:Int, keyword: String, completion: @escaping(Result<PlaceResponse, AFError>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK e09fde1db2267df1c0fe44526622b1b8",
                                    "content-type": "application/json;charset=UTF-8"]
        let parameters: [String: Any] = ["y": y,
                                         "x": x,
                                         "radius": radius,
                                         "page": page,
                                         "query": keyword]
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .responseDecodable(of: PlaceResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
