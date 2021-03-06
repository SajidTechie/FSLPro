//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import CoreLocation

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func slideMenuItemSelectedAtIndex(_ sectionIndex: Int,_ itemIndex: Int,_ screen:String) {
//        let topViewController : UIViewController = self.navigationController!.topViewController!
//        print("View Controller is : \(topViewController) \n", terminator: "")
//        print("Clicked on - - - - ",screen)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        switch(screen){
//
//            //EditProfileViewController
//        case ("Profile"):
//            print("Profile\n", terminator: "")
//
//            self.openViewControllerBasedOnIdentifier("EditProfileViewController","Auth")
//            break
//
//        case ("How To Play"):
//            print("Dashboard\n", terminator: "")
//
//            self.openViewControllerBasedOnIdentifier("HowToPlayViewController","LeftPanel")
//            break
//
//        case ("Point System"):
//            print("About Us\n", terminator: "")
//            self.openViewControllerBasedOnIdentifier("AboutUsViewController","LeftPanel")
//            break
//
//
//        case ("Logout"):
//            print("Logout\n", terminator: "")
//            let defaults = UserDefaults.standard
//            for key in defaults.dictionaryRepresentation().keys {
//                    UserDefaults.standard.removeObject(forKey: key)
//
//            }
//
//            // - - - - - call login here - - - - -
//
//            weak var pvc = self.presentingViewController
//            self.dismiss(animated: false, completion: {
//
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
//                let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
//
//                let navVc = UINavigationController(rootViewController: vcLogin)
//                pvc?.present(navVc, animated: true, completion: nil)
//            })
//            break
//
//        default:
//            print("default\n", terminator: "")
//        }
//    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String,_ storyboard:String){
        let storyBoard: UIStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        let destViewController : UIViewController = storyBoard.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!

        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
        
    }
    
//    func addSlideMenuButton(){
//        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
//        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
//        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
//        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
//        self.navigationItem.rightBarButtonItem = customBarItem;
//    }
//
//
//    func addBackMenuButton(){
//        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
//        btnShowMenu.setImage(UIImage(named: "left_arrow.png"), for: UIControl.State())
//        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onBackMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
//        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
//        self.navigationItem.leftBarButtonItem = customBarItem;
//    }
//
//    @objc func onBackMenuButtonPressed(_ sender : UIButton){
//        self.openViewControllerBasedOnIdentifier("DashboardController","Home")
//        //   self.navigationController?.popViewController(animated: true)
//    }
//
//
//    func defaultMenuImage() -> UIImage {
//        var defaultMenuImage = UIImage()
//
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
//
//        UIColor.black.setFill()
//        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
//        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
//        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
//
//        UIColor.white.setFill()
//        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
//        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
//        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
//
//        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
//
//        UIGraphicsEndImageContext()
//
//        return defaultMenuImage;
//    }
//
//
//    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
//        if (sender.tag == 10)
//        {
//            // To Hide Menu If it already there
//            self.slideMenuItemSelectedAtIndex(-1,-1,"");
//
//            sender.tag = 0;
//
//            let viewMenuBack : UIView = view.subviews.last!
//
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                var frameMenu : CGRect = viewMenuBack.frame
//                frameMenu.origin.x =  UIScreen.main.bounds.size.width
//                viewMenuBack.frame = frameMenu
//                viewMenuBack.layoutIfNeeded()
//                viewMenuBack.backgroundColor = UIColor.clear
//            }, completion: { (finished) -> Void in
//                viewMenuBack.removeFromSuperview()
//            })
//
//            return
//        }
//
//        sender.isEnabled = false
//        sender.tag = 10
//
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let menuVC : MenuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
//        menuVC.btnMenu = sender
//        menuVC.delegate = self
//        self.view.addSubview(menuVC.view)
//        self.addChild(menuVC)
//        menuVC.view.layoutIfNeeded()
//
//
//        menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//            sender.isEnabled = true
//        }, completion:nil)
//    }
}


