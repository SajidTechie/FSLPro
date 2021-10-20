//
//  LeagueController.swift
//  Dummy
//
//  Created by Goldmedal on 23/09/21.
//

import UIKit

class LeagueController: UIViewController {
    
    //ViewPagerControllerDelegate
  
    var mid = Int()
    
    let tabs = [
        ViewPagerTab(title: "LEAGUES", image: UIImage(named: "")),
        ViewPagerTab(title: "MY TEAM", image: UIImage(named: "")),
        ViewPagerTab(title: "MY LEAGUES", image: UIImage(named: ""))
    ]
    var options: ViewPagerOptionsNew?
    var pager:ViewPager?
    
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
        
        
        
        
//        let controller = LeagueViewPagerController()
//        controller.options = options
//        controller.tabs = tabs
//        self.navigationController?.pushViewController(controller, animated: true)
        
    }

}


extension LeagueController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    // Provide ViewController for each page
    func viewControllerAtPosition(position:Int) -> UIViewController {
        var vc = UIViewController()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
        
        if position == 0
        {
            
            vc = storyBoard.instantiateViewController(withIdentifier: "LeaguesTabController") as! LeaguesTabController
            let vcLeague = vc as! LeaguesTabController
            vcLeague.mid = mid
        }
        else if position == 1
        {
            let teamStoryBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
            vc = teamStoryBoard.instantiateViewController(withIdentifier: "MyTeamTabController") as! MyTeamTabController
            let vcMyTeam = vc as! MyTeamTabController
            vcMyTeam.mid = mid
        }
        else if position == 2
        {
            vc = storyBoard.instantiateViewController(withIdentifier: "MyLeaguesTabController") as! MyLeaguesTabController
            let vcMyLeague = vc as! MyLeaguesTabController
           vcMyLeague.mid = mid
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

extension LeagueController: ViewPagerDelegate {
    
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





