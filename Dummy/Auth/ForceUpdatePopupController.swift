//
//  ForceUpdatePopupController.swift
//  Dummy
//
//  Created by Goldmedal on 23/03/22.
//

import UIKit

class ForceUpdatePopupController: UIViewController {

    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    var delegate:CommonDelegate?
    
    var appVersion = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeader.text = "Update \(appVersion) is now available to download. Downloading the latest version will give you latest features,improvements and bug fixes of FSL!"

        // Do any additional setup after loading the view.
    }
  
    @IBAction func cancel_clicked(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: {
            self.delegate?.refreshApi?()
        })
    }
    
    
    @IBAction func ok_clicked(_ sender: UIButton) {

        if let url = URL(string: "itms-apps://itunes.apple.com/us/app/id1615899283"),
            
            UIApplication.shared.canOpenURL(url){
      
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
    }
    
    
}
