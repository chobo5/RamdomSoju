//
//  ResultViewModel.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/09/03.
//

import Foundation

class ResultViewModel {
    
    var place: PlaceModel?
    
    init(place: PlaceModel? = nil) {
        self.place = place
    }

    func findWayButtonTapped() {
        guard let x = self.place?.x else { return }
        guard let y = self.place?.y else { return }
        let goal = x + "," + y
        NotificationCenter.default.post(name: .findPathFromResultViewModel, object: nil, userInfo: ["data": goal])
    }
    
}

extension Notification.Name {
    static let findPathFromResultViewModel = Notification.Name("findPathFromResultViewModel")
}
