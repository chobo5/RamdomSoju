//
//  RouletteViewController.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/08/14.
//

import UIKit
import SnapKit

class RouletteViewController: UIViewController {
    
    var rouletteViewModel: PlaceRouletteViewModel?
    
    var rouletteView = RouletteView()
    
    weak var dismissDelegate: DismissDelegate?
    
    let noStoreImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupRouletteView()
    }
    
    func setupRouletteView() {
        rouletteView.delegate = self
        
        self.view.addSubview(rouletteView)
        self.rouletteView.backgroundColor = .clear
        rouletteView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(rouletteView.snp.width)
        }
        
        guard let rouletteViewModel = rouletteViewModel else { return }
    
        rouletteView.sections = rouletteViewModel.makeSectionList()
        print("sections",rouletteView.sections)
        
        self.view.addSubview(noStoreImage)
        noStoreImage.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        noStoreImage.image = UIImage(named: "noStore")
        noStoreImage.contentMode = .scaleAspectFill
        if rouletteViewModel.rouletteList.value?.count == 0 {
            rouletteView.isHidden = true
            noStoreImage.isHidden = false
        } else {
            rouletteView.isHidden = false
            noStoreImage.isHidden = true
        }
        
        
    }
    
    

}

extension RouletteViewController: RouletteViewDelegate {
    
    func getResultFromRoulette(_ place: String) {
        let resultVC = ResultViewController()
        resultVC.modalPresentationStyle = .overFullScreen
        let placeModel = self.rouletteViewModel?.getPlaceWithName(placeName: place)
        resultVC.viewModel = ResultViewModel(place: placeModel)
        resultVC.dismissDelegate = self.dismissDelegate
        self.present(resultVC, animated: true)
    }
    
    
}
