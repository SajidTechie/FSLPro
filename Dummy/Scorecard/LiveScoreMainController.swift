//
//  LiveScoreMainController.swift
//  Dummy
//
//  Created by Goldmedal on 06/10/21.
//

import UIKit


class LiveScoreMainController: UIViewController, ViewPagerControllerDelegate {
    
    var mid = Int()
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    private var presenter: iScorecardListPresenter!
    private var scorecard: [ScorecardMain] = []
 
    var callFrom = "LIVE"
    
    var tabs = [
        ViewPagerTab(title: "LIVE SCORE", image: UIImage(named: "")),
        ViewPagerTab(title: "SCORECARD", image: UIImage(named: "")),
        ViewPagerTab(title: "ABOUT MATCH", image: UIImage(named: ""))
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
        
        presenter = ScorecardListPresenter(view: self)
        presenter.initInteractor()
        
        Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(self.update),
                             userInfo: nil,
                             repeats: true)
        
    }
    
    // @objc selector expected for Timer
    @objc func update() {
        // do what should happen when timer triggers an event
      
        presenter.getScorecard(mid: 144)
        
    }
    
    
}

extension LiveScoreMainController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        var vc = UIViewController()
        
        
        if position == 0
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "LiveScoreTabController") as! LiveScoreTabController
             let vcLiveScore = vc as! LiveScoreTabController
            vcLiveScore.callFrom = "LIVE"
        }
        else if position == 1
        {
            let teamStoryBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
            vc = teamStoryBoard.instantiateViewController(withIdentifier: "ScorecardViewController") as! ScorecardViewController
            let vcScorecard = vc as! ScorecardViewController
            vcScorecard.callFrom = "LIVE"
        }
        else if position == 2
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "AboutMatchController") as! AboutMatchController
            let vcAboutMatch = vc as! AboutMatchController
            vcAboutMatch.callFrom = "LIVE"
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



extension LiveScoreMainController : ScorecardListPresentable {
    func willLoadData() {
        
    }
    
    func didLoadData() {
        
        scorecard = presenter.scorecard
        
        print("scorecard - - - ",scorecard)
        let scorecardDataDict:[String: [ScorecardMain]] = ["scorecard": scorecard]
        NotificationCenter.default.post(name: NSNotification.Name("LIVE_SCORE"), object: nil, userInfo: scorecardDataDict)
        
    }
    
    func didFail(error: CustomError) {
        
    }
}
