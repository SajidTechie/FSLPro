//
//  JoinLeagueMsgPopup.swift
//  Dummy
//
//  Created by Apple on 25/09/21.
//
import UIKit


class JoinLeagueMsgPopup: UIViewController {

    @IBOutlet weak var lblMessage : UILabel!
    //@IBOutlet weak var btnClose : UIButton!
    var joinMsg = String()
   
    
    @IBAction func clicked_close(_ sender: UIButton) {
     dismiss(animated: true, completion: nil)
//        weak var pvc = self.presentingViewController
//        self.dismiss(animated: false, completion: {
//
//
//            NotificationCenter.default.post(name: .refreshDashboard, object: nil,userInfo: nil)
//
//
//            pvc?.dismiss(animated: true, completion: nil)
//        //Re direct to Dashboard
//         })
    }

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(joinMsg.isEmpty){
            lblMessage.text = "League Joined !"
        }else{
            lblMessage.text = joinMsg
        }
        
        

    }
    
  
}
