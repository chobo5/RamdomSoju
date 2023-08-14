//
//  RouletteViewController.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/08/14.
//

import UIKit

class RouletteViewController: UIViewController {
    
    var rouletteViewModel: PlaceRouletteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("rouletteList", self.rouletteViewModel?.rouletteList.value)
    }
}
