//
//  MatchesViewController.swift
//  Dummy
//
//  Created by Apple on 19/10/21.
//

import UIKit

class MatchesViewController: UIViewController {

//    var tabs = [ViewPagerTab]()
//    var options: ViewPagerOptionsNew?
//    var pager:ViewPager?
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let options = self.options else { return }
//
//        pager = ViewPager(viewController: self)
//        pager?.setOptions(options: options)
//        pager?.setDataSource(dataSource: self)
//        pager?.setDelegate(delegate: self)
//        pager?.build()
        
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}
/*
extension MatchesViewController: ViewPagerDataSource {
    
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

extension MatchesViewController: ViewPagerDelegate {
    
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
*/
