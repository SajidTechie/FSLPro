//
//  HowToPlayViewController.swift
//  Dummy
//
//  Created by Goldmedal on 13/03/22.
//

import UIKit
import WebKit

class HowToPlayViewController: UIViewController {
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var header : Header!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        header.delegate = self
          
        let url = URL(string: Constant.HOW_TO_PLAY_WEB_URL)
           let requestObj = URLRequest(url: url!)
           webView.load(requestObj)
        
        header.bindData(strTitle: "How To Play")
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

}


extension HowToPlayViewController:HandleHeaderBack{
    func onBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
