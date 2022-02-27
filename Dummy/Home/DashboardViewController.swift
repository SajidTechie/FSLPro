//
//  DashboardViewController.swift
//  Dummy
//
//  Created by Goldmedal on 16/09/21.
//

import UIKit
import XLPagerTabStrip
class DashboardViewController: PagerStripController{//,ViewPagerDelegate
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//      //  self.reloadPagerTabStripView()
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.reloadPagerTabStripView()
//    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let upcomingVC = storyBoard.instantiateViewController(withIdentifier: "UpcomingTabController") as! UpcomingTabController
        let liveVC = storyBoard.instantiateViewController(withIdentifier: "LiveTabController") as! LiveTabController
        let completedVC = storyBoard.instantiateViewController(withIdentifier: "CompletedTabController") as! CompletedTabController

        let childViewControllers = [upcomingVC, liveVC, completedVC]
        let count = childViewControllers.count

        
        return Array(childViewControllers.prefix(Int(count)))
        
      
    }
    
}
