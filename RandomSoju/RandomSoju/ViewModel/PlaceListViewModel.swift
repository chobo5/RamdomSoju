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

class PlaceListViewModel {
    
    var resultList: Observable<[Document]>
    
    init() {
        self.resultList = Observable([])
    }
    
    
    func getPlaceWithKeyword(x: String, y: String, radius: Int, page:Int, keyword: String, completion: @escaping (Document) -> Void) {
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
        .responseDecodable(of: PlaceResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                guard let places = data.places else { return }
                self.resultList.value = places.sorted{($0.distance ?? "0" < $1.distance ?? "1")}
                self.resultList.value?.forEach({ place in
                completion(place)
                })
            case .failure(let error):
                print("Error getting places with keyword",error)
            }
        }
    }
    
    
    
    
    
}
