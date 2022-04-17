//
//  GradientRedButton.swift
//  Dummy
//
//  Created by Goldmedal on 26/02/22.
//

import UIKit

class GradientRedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
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
    
    @IBInspectable var startColor: UIColor = UIColor.init(named: "lightRed") ?? UIColor.blue { didSet { updateColors() }}
    @IBInspectable var centerColor: UIColor = UIColor.init(named: "captainRed") ?? UIColor.blue { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = UIColor.init(named: "darkRed") ?? UIColor.cyan { didSet { updateColors() }}
    @IBInspectable var diagonalMode: Bool =  false { didSet { updatePoints() }}
    
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    
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
