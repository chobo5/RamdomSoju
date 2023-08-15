//
//  Roulette.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/08/14.
//

import Foundation
import UIKit

class RouletteView: UIView {
    var sections: [String] = []
    
    var colors: [UIColor] = [.red, .orange, .yellow, .green]
        
    override func draw(_ rect: CGRect) {
        //뷰의 가로 크기
        let width = bounds.width
        //뷰의 세로 크기
        let height = bounds.height
        //반지름
        let radius = min(width, height) * 0.5
        //중심
        let center = CGPoint(x: width * 0.5, y: height * 0.5)
        //하나의 섹션의 호의 길이
        let arc = CGFloat((radius * 2 * .pi) / CGFloat(sections.count))
        
        for (index, section) in sections.enumerated() {
            let startAngle = CGFloat(index) * arc
            let endAngle = CGFloat(index + 1) * arc
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            colors[index].setFill()
            path.fill()
        }
        
        
        
    }
}



