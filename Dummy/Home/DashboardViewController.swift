//
//  DashboardViewController.swift
//  Dummy
//
//  Created by Goldmedal on 16/09/21.
//

import UIKit
import XLPagerTabStrip
class DashboardViewController: PagerStripController,SlideMenuDelegate{//,ViewPagerDelegate
    @IBOutlet weak var vwOverlay : UIView!
    @IBOutlet weak var vwHeaderRight : UIView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblWalletBalance : UILabel!
   
    private var presenter: iMatchesPresenter!
    private var rules: [GetRulesData] = []
    
    override func viewDidLoad() {
     self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        super.viewDidLoad()
        addSlideMenuButton()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       presenter = MatchesPresenter(view: self)
       presenter.initInteractor()
       presenter.getRules(callFrom: Constant.RULES)
       // reloadPagerTabStripView()
      super.viewWillAppear(animated)
    }

    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        let upcomingVC = storyBoard.instantiateViewController(withIdentifier: "UpcomingTabController") as! UpcomingTabController
        let liveVC = storyBoard.instantiateViewController(withIdentifier: "LiveTabController") as! LiveTabController
        let completedVC = storyBoard.instantiateViewController(withIdentifier: "CompletedTabController") as! CompletedTabController

        let childViewControllers = [upcomingVC, liveVC, completedVC]
        let count = childViewControllers.count

        return Array(childViewControllers.prefix(Int(count)))
       
    }
    
    
    
    
    func slideMenuItemSelectedAtIndex(_ sectionIndex: Int,_ itemIndex: Int,_ screen:String) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        print("Clicked on - - - - ",screen)
        self.vwOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        switch(screen){
            
        case ("Profile"):
            print("Profile\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("EditProfileViewController","Auth")
            break
        
        case ("How To Play"):
            print("How To Play\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("HowToPlayViewController","LeftPanel")
            break
            
        case ("Point System"):
            print("Point System\n", terminator: "")
            self.openViewControllerBasedOnIdentifier("PointSystemViewController","LeftPanel")
            break
            
            
        case ("Logout"):
            print("Logout\n", terminator: "")
            
            let defaults = UserDefaults.standard
            for key in defaults.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key)
        
            }
            
            // - - - - - call login here - - - - -
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.navigationController!.pushViewController(vcLogin, animated: true)
            
            
            break
            
        default:
            print("default\n", terminator: "")
        }
    }
    
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
    
    func addSlideMenuButton(){
      //  let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        let btnShowMenu = UIButton(frame: CGRect(x: view.frame.size.width - 55, y: 40, width: 30, height: 30))
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        
    //    btnShowMenu.frame = CGRect(x: view.frame.size.width - 10, y: 20, width: 30, height: 30)
    //    let button1 = UIButton(frame: CGRect(x: view.frame.size.width - 10, y: 20, width: 30, height: 30))
    //    self.view.addSubview(button1)
        btnShowMenu.addTarget(self, action: #selector(self.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
//        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
//        self.navigationItem.rightBarButtonItem = customBarItem;
        self.view.addSubview(btnShowMenu)
    }
    
    
    
//    func addBackMenuButton(){
//        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
//        btnShowMenu.setImage(UIImage(named: "left_arrow.png"), for: UIControl.State())
//        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onBackMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
//        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
//        self.navigationItem.leftBarButtonItem = customBarItem;
//    }
    
    @objc func onBackMenuButtonPressed(_ sender : UIButton){
        self.openViewControllerBasedOnIdentifier("DashboardController","Home")
        //   self.navigationController?.popViewController(animated: true)
    }
    
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
//        UIColor.black.setFill()
//        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
//        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
//        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    
   
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        self.vwOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1,-1,"");

            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x =  UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                 
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let menuVC : MenuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
 
        
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-120);
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-120);
            self.view.alpha = 1
            sender.isEnabled = true
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                self.vwOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            }, completion: nil)
            
        }, completion:nil)
    
        
    }
    
}


extension DashboardViewController : MatchesPresentable {
    func willLoadData(callFrom:String) {
    
    }
    
    func didLoadData(callFrom:String){
        
        rules = presenter.rules
        print("** ** rules ** ** - - - ",rules)
        
        if(rules.count > 0){
            let userName = rules[0].bal?.dN ?? "-"
            lblName.text = userName
            
            let walletBalance = String(rules[0].bal?.bAL ?? 0)
            
            let referralCode = rules[0].bal?.refCode ?? "-"
            
            UserDefaults.standard.set(userName, forKey: "UserName")
            UserDefaults.standard.set(walletBalance, forKey: "WalletBalance")
            UserDefaults.standard.set(referralCode, forKey: "ReferralCode")
            
            lblWalletBalance.text = Utility.getWalletBalance()
        }
       
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getRules(callFrom: Constant.RULES)
        }
    }
}
