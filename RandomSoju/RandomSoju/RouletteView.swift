//
//  Roulette.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/08/14.
//

import UIKit

class RouletteView: UIView {
    
    var sections: [String] = []
    
    var startButton: UIButton!
    
    var arrowImageView: UIImageView!
    
    var rouletteLayer: CALayer!
    
    var colors: [UIColor] = [.rouletteBlue ?? .blue, .rouletteBlue2 ?? .blue, .rouletteBlue3 ?? .blue, .rouletteBlue4 ?? .blue, .rouletteBlue3 ?? .blue, .rouletteBlue2 ?? .blue]
    
    weak var delegate: RouletteViewDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupArrowImageView()
        setupStartButton()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupArrowImageView()
        setupStartButton()
        
    }
    
    override func draw(_ rect: CGRect) {
        rouletteLayer = CALayer()
        rouletteLayer.frame = self.bounds
        rouletteLayer.zPosition = -1
        self.layer.addSublayer(rouletteLayer)
        //MARK: - 룰렛뷰
        //뷰의 가로 크기
        let width = bounds.width
        //뷰의 세로 크기
        let height = bounds.height
        //반지름
        let radius = min(width, height) * 0.5
        //중심
        let center = CGPoint(x: width * 0.5, y: height * 0.5)
        //하나의 섹션의 호의 각도
        let arcAngle = CGFloat((2 * Double.pi) / CGFloat(sections.count))
        
        for (index, section) in sections.enumerated() {
            let startAngle = CGFloat(index) * arcAngle - CGFloat(Double.pi / 2)
            let endAngle = CGFloat(index + 1) * arcAngle - CGFloat(Double.pi / 2)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = colors[index % colors.count].cgColor
            rouletteLayer.addSublayer(shapeLayer)
//            colors[index % colors.count].setFill()
//            path.fill()
            
            
            let textLayer = CATextLayer()
            let angle = startAngle + (arcAngle * 0.5)
            let textPosition = CGPoint(x: center.x + (radius * 0.6 * cos(angle)), y: center.y + (radius * 0.6 * sin(angle)))
            textLayer.string = section

            textLayer.fontSize = 14
            textLayer.foregroundColor = UIColor.gray.cgColor
            textLayer.alignmentMode = .center
            textLayer.position = textPosition
            textLayer.isWrapped = true
            textLayer.bounds = CGRect(x: 0, y: 0, width: 28, height: radius * 0.5)
            rouletteLayer.addSublayer(textLayer)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        startButton.layer.cornerRadius = startButton.frame.width / 2
        
    }
        
    private func setupArrowImageView() {
        //MARK: - 룰레의 화살표 이미지뷰
        arrowImageView = UIImageView(image: UIImage(systemName: "arrowshape.right.fill"))
        self.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            arrowImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            arrowImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1)
        ])
        arrowImageView.transform = arrowImageView.transform.rotated(by: .pi / 2)
        arrowImageView.tintColor = .red
    }
    
    private func setupStartButton() {
        //MARK: - 룰렛회전 버튼
        startButton = UIButton()
        startButton.setTitle("start", for: .normal)
        startButton.setTitleColor(.gray, for: .normal)
        self.addSubview(startButton)
        startButton.bringSubviewToFront(self)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            startButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15)
        ])
        startButton.backgroundColor = UIColor.rouletteIvory
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.addTarget(self, action: #selector(spinRoulette(sender:)), for: .touchUpInside)
    }
    
    
    
    
    @objc private func spinRoulette(sender: UIButton) {
        let duration: CFTimeInterval = 5
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let randomNumber = Double.random(in: 0...2)
        rotationAnimation.byValue = -(20 * Double.pi + (randomNumber * Double.pi))
        rotationAnimation.duration = duration
        // easeOut 타이밍 함수를 사용하여 빠르게 시작하고 천천히 멈추게 합니다.
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        // 애니메이션이 끝나도 레이어는 애니메이션의 마지막 상태를 유지합니다.
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        
        rouletteLayer.add(rotationAnimation, forKey: "spinRoulette")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration + 0.5) {
            if let place = self.getSectionTextBelowArrow(randomNumber: randomNumber) {
                self.delegate?.getResultFromRoulette(place)
            }
        }
    }
    
    func getSectionTextBelowArrow(randomNumber: Double) -> String? {
        let totalSections = sections.count
        
//        guard totalSections > 0 else { return nil }
        let sectionArc = (2 * Double.pi) / Double(totalSections)
        let randomArc = randomNumber * Double.pi
        let sectionIndex = Int(floor(randomArc / sectionArc))
        return sections[sectionIndex]
        
    }
    
}

protocol RouletteViewDelegate: AnyObject {
    func getResultFromRoulette(_ place: String)
}



