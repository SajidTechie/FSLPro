//
//  DashboardViewController.swift
//  Dummy
//
//  Created by Goldmedal on 16/09/21.
//

import UIKit

class DashboardViewController: BaseViewController, ViewPagerControllerDelegate {

    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    var tabs = [
        ViewPagerTab(title: "Upcoming", image: UIImage(named: "")),
        ViewPagerTab(title: "Live", image: UIImage(named: "")),
        ViewPagerTab(title: "Completed", image: UIImage(named: ""))
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        addSlideMenuButton()
        
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 4)
        
        options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.imageWithText
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 13)
        options.isEachTabEvenlyDistributed = true
        options.tabViewBackgroundDefaultColor = UIColor.white
        if #available(iOS 11.0, *) {
            options.tabIndicatorViewBackgroundColor = UIColor.init(named: "ColorRed") ?? UIColor.red
        } else {
            options.tabIndicatorViewBackgroundColor = UIColor.red
        }
        options.fitAllTabsInView = true
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = false
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChild(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
  
    }
  
}



extension DashboardViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        var vc = UIViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        if position == 0
        {
            
            vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingTabController") as! UpcomingTabController
        }
        else if position == 1
        {
            vc = storyboard?.instantiateViewController(withIdentifier: "LiveTabController") as! LiveTabController
        }
        else if position == 2
        {
            vc = storyboard?.instantiateViewController(withIdentifier: "CompletedTabController") as! CompletedTabController
        }
        
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
    
}

