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
    var place: PlaceModel?
    
    
    weak var delegate: UpdateRouletteList?
    
    var isSelectedChanged: ((PlaceModel) -> Void)?
    
    init(place: PlaceModel) {
        self.place = place
    
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
    
    
    

    
   
}

protocol UpdateRouletteList: AnyObject {
    func addPlace(place: PlaceModel)
    func removePlace(place: PlaceModel)
}
