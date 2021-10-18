//
//  LeagueController.swift
//  Dummy
//
//  Created by Goldmedal on 23/09/21.
//

import UIKit

class LeagueController: UIViewController, ViewPagerControllerDelegate {
  
    var mid = Int()
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    var tabs = [
        ViewPagerTab(title: "League", image: UIImage(named: "")),
        ViewPagerTab(title: "My Team", image: UIImage(named: "")),
        ViewPagerTab(title: "My League", image: UIImage(named: ""))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension LeagueController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
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
