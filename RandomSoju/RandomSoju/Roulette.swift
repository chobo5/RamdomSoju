//
//  Roulette.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/08/14.
//

import Foundation
import UIKit

class Roulette: UIView {
    /**Size of the imageView which indcates which slice has been selected*/
    private lazy var indicatorSize : CGSize = {
    let size = CGSize.init(width: self.bounds.width * 0.126 , height: self.bounds.height * 0.126)
    return size }()

    /**The number slices the wheel has to be divided into is determined by this array count and
    each slice object contains its corresponding slices Data.*/
    private var slices : [Slice]?

    /**ImageView that holds an image which indicates which slice has been selected.*/
    private var indicator = UIImageView.init()

    /**Button which starts the spin game.This is places at the center of wheel.*/
    var playButton : UIButton = UIButton.init(type: .custom)

    /**Angle each slice occupies.*/
    private var sectorAngle : Radians = 0

    /**The view on which the slices will be drawn.This view will be roatated to simuate the spin.*/
    private var wheelView : UIView!

    /**Creates and returns an FortuneWheel with its center aligned to center CGPoint , diameter and slices drawn*/
    init(center: CGPoint, diameter : CGFloat , slices : [Slice])
    {
       super.init(frame: CGRect.init(origin: CGPoint.init(x: center.x - diameter/2, y: center.y - diameter/2), size: CGSize.init(width: diameter, height: diameter)))
       self.slices = slices
       self.initialSetUp()
     }

     /**The setup of the fortune wheel is done here.*/
     private func initialSetUp()
     {
        
     }
}


class Slice {
    var color = UIColor.clear
    
    var text: UILabel
    
    var borderColor = UIColor.black
    
    var borderWidth: CGFloat = 1
    
    init(text: UILabel) {
        self.text = text
    }
}
