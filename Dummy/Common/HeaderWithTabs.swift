//
//  HeaderWithTabs.swift
//  Dummy
//
//  Created by Goldmedal on 16/03/22.
//

import Foundation
import UIKit

@IBDesignable class HeaderWithTabs: BaseCustomView {
    @IBOutlet weak var imvBack : UIImageView!
    @IBOutlet weak var lblHeader : UILabel!
    
    var delegate: HandleHeaderBack?
    
    override func xibSetup() {
        super.xibSetup()
        
        let tabBackImage = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        imvBack.addGestureRecognizer(tabBackImage)

    }
    
    func bindData(strTitle:String){
        lblHeader.text = strTitle
    }
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("Edit Icon Clicked")
        delegate?.onBackClick()
     
        
    }
  
    
    
}
