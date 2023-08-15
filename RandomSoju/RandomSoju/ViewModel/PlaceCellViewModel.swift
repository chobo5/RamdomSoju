//
//  PlaceCellViewModel.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/08/09.
//

import UIKit
import SwiftSoup
import Alamofire

class PlaceCellViewModel {
    var place: Document?
    
    
    weak var delegate: UpdateRouletteList?
    
    var isSelectedChanged: ((Document) -> Void)?
    
    init(place: Document) {
        self.place = place
        
//        if let placeUrl = self.place?.placeURL {
//            crawlPlaceImage(urlStr: placeUrl)
//        }
    }
    
    
    
    func updateSelectedPlace() {
        self.place?.isSelected.toggle()
        if let place = self.place {
            isSelectedChanged?(place) //placeListViewModel 데이터 변경
            if place.isSelected == true {
                self.delegate?.addPlace(place: place) //rouletteViewModel 데이터 변경
            } else {
                self.delegate?.removePlace(place: place) //rouletteViewModel 데이터 변경
            }
        }
    }
    
    
    
//    func crawlPlaceImage(urlStr: String) {
//        let httpsUrlStr = urlStr.replacingOccurrences(of: "http", with: "https")
//        print("gear",httpsUrlStr)
//        let header: HTTPHeaders = [
//            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
//        ]
//        AF.request(httpsUrlStr, headers: header).responseString { (response) in
//
//            guard let html = response.value else { return }
//            do {
////                print(html)
//                let doc = try SwiftSoup.parse(html)
////                print(doc)
//                if let element = try doc.select("#mArticle > div.cont_essential > div:nth-child(1) > div.details_present > a > span.bg_present").first() {
//                    let styleValue = try element.attr("style")
//                    print("gear", styleValue)
//
//                } else {
//                    print("gearNo")
//                }
//            } catch {
//                print("crawl error")
//            }
//
//
//        }
//    }
    
   
}

protocol UpdateRouletteList: AnyObject {
    func addPlace(place: Document)
    func removePlace(place: Document)
}
