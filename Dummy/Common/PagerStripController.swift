//
//  PagerStripController.swift
//  Dummy
//
//  Created by Goldmedal on 20/02/22.
//

import UIKit
import XLPagerTabStrip

class PagerStripController: ButtonBarPagerTabStripViewController {

    
    override func viewDidLoad() {
      
       
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
      //  settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont(name: "ConthraxSb-Regular", size:10) ?? UIFont.systemFont(ofSize: 10)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.selectedBarBackgroundColor = UIColor.white
        
        super.viewDidLoad()
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.init(named: "unselectedTabTextColor") ?? .gray
            newCell?.label.textColor = .white
        }
        
    }
  
}
