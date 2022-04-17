//
//  CustomImageView.swift
//  dealersApp
//
//  Created by Rahul Bangde on 19/08/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0
        {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
   @IBInspectable  var borderColor: UIColor = UIColor.clear
        {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable override var tintColor: UIColor! {
        didSet {
            guard let imageNew = self.image else {
               return
            }
             self.image = imageNew.withRenderingMode(.alwaysTemplate)
        }
    }

}
