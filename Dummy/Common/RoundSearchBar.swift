//
//  RoundSearchBar.swift
//  dealersApp
//
//  Created by Goldmedal on 8/17/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundSearchBar : UISearchBar
{
   @IBInspectable  var cornerRadius: CGFloat = 0
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

   @IBInspectable  var borderColor: UIColor = UIColor.clear
        {
        didSet {
            self.layer.borderColor = borderColor.cgColor
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

}

