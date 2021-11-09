//
//  DashboardViewController.swift
//  Dummy
//
//  Created by Goldmedal on 16/09/21.
//

import UIKit

class DashboardViewController: BaseViewController{//,ViewPagerDelegate
   

    let tabs = [
        ViewPagerTab(title: "UPCOMING", image: UIImage(named: "")),
        ViewPagerTab(title: "LIVE", image: UIImage(named: "")),
        ViewPagerTab(title: "COMPLETED", image: UIImage(named: ""))
    ]
    var options: ViewPagerOptionsNew?
    var pager:ViewPager?
    
    @IBOutlet weak var vwHorizontalStrip: UIView!
    
    override func loadView() {
        
        let newView = UIView()
        newView.backgroundColor = UIColor.white
        
        view = newView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = ViewPagerOptionsNew()
        options.tabType = .basic
        options.distribution = .segmented
        options.isTabHighlightAvailable = true
        options.tabViewHeight = 30
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.tabIndicatorViewBackgroundColor = .white
        options.tabViewTextDefaultColor = UIColor.init(named: "unselectedTabBlue") ?? UIColor.blue
        options.tabViewTextHighlightColor = .white
        options.tabViewTextFont = UIFont(name:"UbuntuMedium",size:14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
     
        
        
        //guard let options = self.options else { return }
        
        pager = ViewPager(viewController: self)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
        
        

    }
   
}




//extension DashboardViewController: ViewPagerControllerDataSource {
//
//    func numberOfPages() -> Int {
//        return tabs.count
//    }
//
//    func viewControllerAtPosition(position:Int) -> UIViewController {
//        var vc = UIViewController()
//
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//
//        if position == 0
//        {
//
//            vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingTabController") as! UpcomingTabController
//        }
//        else if position == 1
//        {
//            vc = storyboard?.instantiateViewController(withIdentifier: "LiveTabController") as! LiveTabController
//        }
//        else if position == 2
//        {
//            vc = storyboard?.instantiateViewController(withIdentifier: "CompletedTabController") as! CompletedTabController
//        }
//
//        return vc
//    }
//
//    func tabsForPages() -> [ViewPagerTab] {
//        return tabs
//    }
//
//    func startViewPagerAtIndex() -> Int {
//        return 0
//    }
//
//}

//extension DashboardViewController : ViewPagerDataSource {
//    // Provide number of pages required
//    func numberOfPages() -> Int {
//        return tabs.count
//    }
//
//
//    // Provide info for each tab
//    func tabsForPages() -> [ViewPagerTab] {
//        return tabs
//    }
//
//    // Yayy! I can start from any page
//    func startViewPagerAtIndex()->Int {
//        return 0
//    }
//    // Provide ViewController for each page
//    func viewControllerAtPosition(position:Int) -> UIViewController {
//        var vc = UIViewController()
//
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//
//        if position == 0
//        {
//
//            vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingTabController") as! UpcomingTabController
//        }
//        else if position == 1
//        {
//            vc = storyboard?.instantiateViewController(withIdentifier: "LiveTabController") as! LiveTabController
//        }
//        else if position == 2
//        {
//            vc = storyboard?.instantiateViewController(withIdentifier: "CompletedTabController") as! CompletedTabController
//        }
//
//        return vc
//    }
//
//
//}
//
extension DashboardViewController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {

        var vc = UIViewController()
        
        let homeSB: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        if position == 0
        {
            
            vc = homeSB.instantiateViewController(withIdentifier: "UpcomingTabController") as! UpcomingTabController
        }
        else if position == 1
        {
            vc = homeSB.instantiateViewController(withIdentifier: "LiveTabController") as! LiveTabController
        }
        else if position == 2
        {
            vc = homeSB.instantiateViewController(withIdentifier: "CompletedTabController") as! CompletedTabController
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

extension DashboardViewController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
        
    }
    
    
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
        
        
        if(pager?.tabsViewList.count ?? 0 > 0){
            for i in 0..<pager!.tabsViewList.count {
                if(index == i){
                    pager!.tabsViewList[i].adjustFontSize(fontSize: 14.0)
                }else{
                    pager!.tabsViewList[i].adjustFontSize(fontSize: 12.0)
                }
          
            }
        }
    }
}

