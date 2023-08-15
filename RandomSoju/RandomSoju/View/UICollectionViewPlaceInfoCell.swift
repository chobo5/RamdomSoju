//
//  UICollectionViewPlaceInfoCell.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/07/24.
//

import UIKit
import Kingfisher

class UICollectionViewPlaceInfoCell: UICollectionViewCell {
    
    var placeImageView: UIImageView!
    var placeNameLabel: UILabel!
    var distanceLabel: UILabel!
    var phoneLabel: UILabel!
    var addButton: UIButton!
    var cellViewModel: PlaceCellViewModel?
    
    // 프로그래밍 방식으로 뷰를 생성할 때 호출. frame 매개변수는 새로 생성된 뷰의 크기와 위치를 결정.
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupUI() {
        self.placeImageView = UIImageView()
        self.placeNameLabel = UILabel()
        self.distanceLabel = UILabel()
        self.phoneLabel = UILabel()
        self.addButton = UIButton()
        
        self.contentView.addSubview(placeImageView)
        self.contentView.addSubview(placeNameLabel)
        self.contentView.addSubview(distanceLabel)
        self.contentView.addSubview(phoneLabel)
        self.contentView.addSubview(addButton)
        
        self.placeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.placeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.placeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.placeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.placeImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.7)

        ])
        
        NSLayoutConstraint.activate([
            self.placeNameLabel.topAnchor.constraint(equalTo: self.placeImageView.bottomAnchor),
            self.placeNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),

        ])
        
        NSLayoutConstraint.activate([
            self.distanceLabel.topAnchor.constraint(equalTo: self.placeNameLabel.bottomAnchor, constant: 5),
            self.distanceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),


        ])
        
        NSLayoutConstraint.activate([
            self.phoneLabel.topAnchor.constraint(equalTo: self.placeNameLabel.bottomAnchor, constant: 5),
            self.phoneLabel.leadingAnchor.constraint(equalTo: self.distanceLabel.trailingAnchor, constant: 10),


        ])
        
        NSLayoutConstraint.activate([
            self.addButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.addButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.addButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.2),
            self.addButton.widthAnchor.constraint(equalTo: self.addButton.heightAnchor, multiplier: 1)
        ])
        
    }
    
    func configure(with viewModel: PlaceCellViewModel) {
        contentView.backgroundColor = .white
        placeImageView.backgroundColor = .yellow
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = contentView.frame.height * 0.15
        
        placeNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        phoneLabel.font = UIFont.systemFont(ofSize: 13)
        
        placeNameLabel.textColor = .black
        distanceLabel.textColor = .black
        phoneLabel.textColor = .black
        
        placeNameLabel.text = viewModel.place?.placeName
        if let distance = viewModel.place?.distance {
            distanceLabel.text = distance + "m"
        }
        
        phoneLabel.text = viewModel.place?.phone
        let url = URL(string: "https://t1.kakaocdn.net/thumb/T800x0.q80/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flocal%2FkakaomapPhoto%2Freview%2F09ffeaab0bbc9e6857affbb3e1775bfa15ef34dd%3Foriginal")
        placeImageView.kf.setImage(with: url)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        let normalImage = UIImage(systemName: "plus.app", withConfiguration: imageConfig)
        let selectedImage = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
        addButton.setImage(selectedImage, for: .selected)
        addButton.setImage(normalImage, for: .normal)
        
        guard let isSelected = viewModel.place?.isSelected else { return }
        if isSelected {
            addButton.isSelected = true
        } else {
            addButton.isSelected = false
        }
        
        
        addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        self.cellViewModel?.updateSelectedPlace()
        guard let isSelected = self.cellViewModel?.place?.isSelected else {print("famlk"); return }
        if isSelected {
            sender.isSelected = true
        } else {
            sender.isSelected = false
        }
        
        
    }
        
    
    
    
}
