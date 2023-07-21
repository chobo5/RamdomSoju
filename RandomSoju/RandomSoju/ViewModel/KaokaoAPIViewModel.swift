//
//  HomeViewModel.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/07/17.
//

import Foundation
import Alamofire
import SwiftyJSON

class KakaoAPIViewModel {
    
//    var resultList = [Keyword]()
    
    func findPlaceInCategory(x: String, y: String, radius: Int, keyword: String) {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK e09fde1db2267df1c0fe44526622b1b8",
                                    "content-type": "application/json;charset=UTF-8"]
        let parameters: [String: Any] = ["y": y,
                                      "x": x,
                                      "radius": radius,
                                      "query": keyword]
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .responseDecodable(of: Keyword.self) {response in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
