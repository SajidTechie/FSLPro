//
//  LeaderboardDetailController.swift
//  Dummy
//
//  Created by Goldmedal on 30/10/21.
//

import UIKit

class LeaderboardDetailController: UIViewController {

    let tabs = [
        ViewPagerTab(title: "LEADERBOARD", image: UIImage(named: "")),
        ViewPagerTab(title: "SCORECARD", image: UIImage(named: "")),
    ]
    
    var options: ViewPagerOptionsNew?
    var pager:ViewPager?
  
    var mid = Int()
    var lid = Int()
    
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
   
        pager = ViewPager(viewController: self)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
    
    }
   
}


extension LeaderboardDetailController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {

        var vc = UIViewController()
        
        let scorecardSB: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
        
        if position == 0
        {
            
            vc = scorecardSB.instantiateViewController(withIdentifier: "LeaderboardRankController") as! LeaderboardRankController
            let vcLeaderboardRank = vc as! LeaderboardRankController
            vcLeaderboardRank.mid = mid
            vcLeaderboardRank.lid = lid
        }
        else if position == 1
        {
            vc = scorecardSB.instantiateViewController(withIdentifier: "ScorecardViewController") as! ScorecardViewController
            let vcScorecard = vc as! ScorecardViewController
            vcScorecard.mid = mid
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

extension LeaderboardDetailController: ViewPagerDelegate {
    
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

