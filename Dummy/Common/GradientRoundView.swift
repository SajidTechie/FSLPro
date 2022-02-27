//
//  GradientRoundView.swift
//  Dummy
//
//  Created by Goldmedal on 22/02/22.
//

import UIKit

class GradientRoundView: UIView {
    
    @IBInspectable   var cornerRadius: CGFloat = 0
      {
          didSet {
              self.layer.cornerRadius = cornerRadius
          }
      }


     @IBInspectable  var borderWidth: CGFloat = 0
         {
          didSet {
              self.layer.borderWidth = borderWidth
          }
      }

     @IBInspectable var borderColor: UIColor = UIColor.clear
          {
          didSet {
              self.layer.borderColor = borderColor.cgColor
          }
      }

    @IBInspectable var startColor: UIColor = UIColor.init(named: "lightBlue") ?? UIColor.blue { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = UIColor.init(named: "darkBlue") ?? UIColor.cyan { didSet { updateColors() }}
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
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        
        updatePoints()
        updateColors()
        
        
    }
}
