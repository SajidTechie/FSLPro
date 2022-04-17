//
//  PointSystemViewController.swift
//  Dummy
//
//  Created by Goldmedal on 13/03/22.
//

import UIKit
import WebKit

class PointSystemViewController: UIViewController {
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var header : Header!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        header.delegate = self
              
        let url = URL(string: Constant.POINTS_WEB_URL)
           let requestObj = URLRequest(url: url!)
           webView.load(requestObj)
        
        header.bindData(strTitle: "Points System")
    }
    
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
  

}

extension PointSystemViewController:HandleHeaderBack{
    func onBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
