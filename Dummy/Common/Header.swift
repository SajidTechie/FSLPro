//
//  Header.swift
//  Dummy
//
//  Created by Goldmedal on 21/02/22.
//

import Foundation
import UIKit

protocol HandleHeaderBack{
    func onBackClick()
}


@IBDesignable class Header: BaseCustomView {
    @IBOutlet weak var imvBack : UIImageView!
    @IBOutlet weak var lblHeader : UILabel!
    var delegate: HandleHeaderBack?
    
    override func xibSetup() {
        super.xibSetup()
        
        
        let tabBackImage = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        imvBack.addGestureRecognizer(tabBackImage)

    }
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("Edit Icon Clicked")
        delegate?.onBackClick()
     
        
    }
  
    
    
}
