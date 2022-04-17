//
//  PaddingLabel.swift
//  dealersApp
//
//  Created by Goldmedal on 8/16/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingLabel: UILabel {
    
    @IBInspectable
      var letterSpace: CGFloat {
          set {
              let attributedString: NSMutableAttributedString!
              if let currentAttrString = attributedText {
                  attributedString = NSMutableAttributedString(attributedString: currentAttrString)
              }
              else {
                  attributedString = NSMutableAttributedString(string: text ?? "")
                  text = nil
              }

              attributedString.addAttribute(NSAttributedString.Key.kern,
                                             value: newValue,
                                             range: NSRange(location: 0, length: attributedString.length))

              attributedText = attributedString
          }

          get {
              if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                  return currentLetterSpace
              }
              else {
                  return 0
              }
          }
      }
    
    @IBInspectable var topInset: CGFloat = 5.0
       @IBInspectable var bottomInset: CGFloat = 5.0
       @IBInspectable var leftInset: CGFloat = 7.0
       @IBInspectable var rightInset: CGFloat = 7.0

       override func drawText(in rect: CGRect) {
           let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
           super.drawText(in: rect.inset(by: insets))
       }

       override var intrinsicContentSize: CGSize {
           let size = super.intrinsicContentSize
           return CGSize(width: size.width + leftInset + rightInset,
                         height: size.height + topInset + bottomInset)
       }

       override var bounds: CGRect {
           didSet {
               // ensures this works within stack views if multi-line
               preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
           }
       }
    
//   @IBInspectable  var topInset: CGFloat = 0.0
//   @IBInspectable   var bottomInset: CGFloat = 0.0
//   @IBInspectable  var leftInset: CGFloat = 0.0
//   @IBInspectable  var rightInset: CGFloat = 0.0
//
//  override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//       // super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    
//    }
//
//  override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//        return CGSize(width: size.width + leftInset + rightInset,
//                      height: size.height + topInset + bottomInset)
//    }
}
