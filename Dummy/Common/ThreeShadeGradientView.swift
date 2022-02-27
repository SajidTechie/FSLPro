//
//  ThreeShadeGradientView.swift
//  Dummy
//
//  Created by Goldmedal on 27/02/22.
//

import UIKit
import Foundation

@IBDesignable
class ThreeShadeGradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.init(named: "startGradient") ?? UIColor.blue { didSet { updateColors() }}
    @IBInspectable var centerColor: UIColor = UIColor.init(named: "centerGradient") ?? UIColor.blue { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = UIColor.init(named: "endGradient") ?? UIColor.cyan { didSet { updateColors() }}
    @IBInspectable var diagonalMode: Bool =  true { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    
    
    func updatePoints() {
        if diagonalMode {
            
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else {
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
      
        }
    }
    
    
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor,centerColor.cgColor, endColor.cgColor]
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        
        updatePoints()
        updateColors()
        
        
    }
}

