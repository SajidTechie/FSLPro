//
//  CommonAlert.swift
//  Dhanbarse
//
//  Created by Goldmedal on 8/12/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation

protocol alertDelegate
{
    func okAction(controller:UIViewController)
    func cancelAction(controller:UIViewController)
}

class CommonAlert : NSObject {
    
    var delegate: alertDelegate?
    
    func showActionAlertView(title:String,message:String,vc:UIViewController) -> Void {
        let Alert = UIAlertController(title: title, message:  message, preferredStyle: UIAlertController.Style.alert)
        
        Alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.delegate?.okAction(controller: vc)
        }))
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.delegate?.cancelAction(controller: vc)
        }))
        
        vc.present(Alert, animated: true, completion: nil)
    }
}
