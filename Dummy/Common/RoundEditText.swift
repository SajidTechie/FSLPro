//
//  RoundEditText.swift
//  dealersApp
//
//  Created by Goldmedal on 8/3/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundEditText : UITextField
{
    private var maxLengths = [UITextField: Int]()
    
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
    
    @IBInspectable var borderColor: UIColor = UIColor.clear
        {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

     var rightImageShow: Bool = false {
        didSet {
            if rightImageShow == true {
                self.rightViewMode = UITextField.ViewMode.always

                let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.height, height: self.bounds.size.height))

                let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: self.bounds.size.height-20, height: self.bounds.size.height-20))

                let button = UIButton(frame: CGRect(x: 0, y: 10, width: self.bounds.size.height-20, height: self.bounds.size.height-20))
                button.addTarget(self, action: #selector(showText), for: .touchUpInside)
                imageView.contentMode = .scaleAspectFit
                view.addSubview(button)
                view.addSubview(imageView)
                self.rightView = view
                view.tag = 1111101
                imageView.tag = 11111012
            }

        }
    }
    
     var rightImageNamed: String = "" {
        didSet {
            if rightImageShow {
                let viewSource = self.rightView?.viewWithTag(1111101)
                let imageView = viewSource!.viewWithTag(11111012) as! UIImageView
                imageView.image = UIImage(named: rightImageNamed)

            }

        }
    }
    
    @objc func showText() {
        let viewSource = self.rightView?.viewWithTag(1111101)
        let imageView = viewSource!.viewWithTag(11111012) as! UIImageView


        if self.isSecureTextEntry {
            self.isSecureTextEntry = false
            imageView.image = UIImage(named: "eye")


        }
        else{
            self.isSecureTextEntry = true
            imageView.image = UIImage(named: "eye")

        }
    }
    
    
    @IBInspectable var doneAccessory: Bool{
               get{
                   return self.doneAccessory
               }
               set (hasDone) {
                   if hasDone{
                       addDoneButtonOnKeyboard()
                   }
               }
           }

           func addDoneButtonOnKeyboard()
           {
               let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
               doneToolbar.barStyle = .default

               let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
               let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

               let items = [flexSpace, done]
               doneToolbar.items = items
               doneToolbar.sizeToFit()

               self.inputAccessoryView = doneToolbar
           }

           @objc func doneButtonAction() {
               self.resignFirstResponder()
           }
    
    
    @IBInspectable var maxLength: Int {
      get {
        // 4
        guard let length = maxLengths[self] else {
          return Int.max
        }
        return length
      }
      set {
        maxLengths[self] = newValue
        // 5
        addTarget(
          self,
          action: #selector(limitLength),
          for: UIControl.Event.editingChanged
        )
      }
    }
    
    @objc func limitLength(textField: UITextField) {
      // 6
      guard let prospectiveText = textField.text,
                prospectiveText.count > maxLength
      else {
        return
      }
      
      let selection = selectedTextRange
      // 7
      let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
      text = prospectiveText.substring(to: maxCharIndex)
      selectedTextRange = selection
    }

    
}
