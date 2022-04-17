//
//  CompletedMatchDetailController.swift
//  Dummy
//
//  Created by Goldmedal on 28/10/21.
//

import UIKit

class CompletedMatchDetailController:  UIViewController {
    
    var mid = Int()
    @IBOutlet weak var header : HeaderWithTabs!
    var tabs = [ViewPagerTab]()
    @IBOutlet weak var vwHorizontalStrip: UIView!
    var pager:ViewPager?
    let options = ViewPagerOptions()
    var callFromScreen = String()
    
    weak var timer: Timer?

    @IBOutlet weak var vwMain: RoundView!
    
    private var presenter: iScorecardListPresenter!
    private var scorecard: [ScorecardMain] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        presenter = ScorecardListPresenter(view: self)
        presenter.initInteractor()
        presenter.getScorecard(mid: mid, callFrom: Constant.SCORECARD)
       
        if(callFromScreen.elementsEqual("LIVE")){
            tabs = [
               ViewPagerTab(title: "LIVE", image: UIImage(named: "")),
               ViewPagerTab(title: "SCORECARD", image: UIImage(named: "")),
               ViewPagerTab(title: "ABOUT MATCH", image: UIImage(named: ""))
           ]
            
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: Constant.LIVE_REFRESH_RATE,
                                 target: self,
                                 selector: #selector(self.update),
                                 userInfo: nil,
                                 repeats: true)
            }
        }else{
            tabs = [
               ViewPagerTab(title: "SCORECARD", image: UIImage(named: "")),
               ViewPagerTab(title: "ABOUT MATCH", image: UIImage(named: ""))
           ]
        }
        
        options.tabType = ViewPagerTabType.basic
        options.tabViewTextFont = UIFont(name: "Ubuntu Medium", size:12) ?? UIFont.systemFont(ofSize: 12)
        options.tabViewTextDefaultColor = UIColor.lightText
        options.tabViewTextHighlightColor = UIColor.white
        options.distribution = .segmented
        options.tabViewBackgroundDefaultColor = UIColor.clear
        options.tabViewBackgroundHighlightColor = UIColor.clear
        options.isTabHighlightAvailable = true
        options.isTabIndicatorAvailable = true
        options.tabViewPaddingLeft = 20
        options.tabIndicatorViewBackgroundColor = UIColor.white
        options.tabIndicatorViewHeight = 4
        options.tabViewPaddingRight = 20
        options.tabViewHeight = 30
        
    
        
        pager = ViewPager(viewController: self,containerView: self.vwMain)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("** ** ** deinit CompletedMatchDetailController ** ** ** ")
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
//    NotificationCenter.default.removeObserver(self)
    
    @objc func update() {
        // do what should happen when timer triggers an event
        print("** ** ** CompletedMatchDetailController ** ** ** ")
        presenter.getScorecard(mid: mid, callFrom: Constant.SCORECARD)
    }

}

extension CompletedMatchDetailController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        var vc = UIViewController()
        
        if(callFromScreen.elementsEqual("LIVE")){
            if position == 0
           {
               let teamStoryBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
               vc = teamStoryBoard.instantiateViewController(withIdentifier: "LiveScoreTabController") as! LiveScoreTabController
               let vcLiveScorecard = vc as! LiveScoreTabController
                vcLiveScorecard.scorecard = scorecard
                vcLiveScorecard.callFrom = "LIVE"
           }
           else if position == 1
           {
               let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
               vc = storyBoard.instantiateViewController(withIdentifier: "ScorecardViewController") as! ScorecardViewController
               let vcFullScorecard = vc as! ScorecardViewController
               vcFullScorecard.scorecard = scorecard
               vcFullScorecard.callFrom = "LIVE"
           }
            else if position == 2
            {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
                vc = storyBoard.instantiateViewController(withIdentifier: "AboutMatchWithoutHeaderController") as! AboutMatchWithoutHeaderController
                let vcAboutMatch = vc as! AboutMatchWithoutHeaderController
                vcAboutMatch.scorecard = scorecard
                vcAboutMatch.callFrom = "LIVE"
            }
        }else{
            if position == 0
           {
               let teamStoryBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
               vc = teamStoryBoard.instantiateViewController(withIdentifier: "ScorecardViewController") as! ScorecardViewController
               let vcScorecard = vc as! ScorecardViewController
                vcScorecard.mid = mid
               vcScorecard.callFrom = "COMPLETED"
           }
           else if position == 1
           {
               let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
               vc = storyBoard.instantiateViewController(withIdentifier: "AboutMatchWithoutHeaderController") as! AboutMatchWithoutHeaderController
               let vcAboutMatch = vc as! AboutMatchWithoutHeaderController
               vcAboutMatch.mid = mid
               vcAboutMatch.callFrom = "COMPLETED"
           }
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

extension CompletedMatchDetailController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}

extension CompletedMatchDetailController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
        
    }

    func didLoadData(callFrom:String){

        scorecard = presenter.scorecard

        print("scorecard - - - ",scorecard)
        let scorecardDataDict:[String: [ScorecardMain]] = ["scorecard": scorecard]
        let res = scorecard[0].info?.res ?? ""
        
        header.bindData(strTitle: res)
        NotificationCenter.default.post(name: NSNotification.Name("LIVE_SCORE"), object: nil, userInfo: scorecardDataDict)
       
    }

    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getScorecard(mid: mid, callFrom: Constant.SCORECARD)
        }
    }
}

extension CompletedMatchDetailController:HandleHeaderBack{
    func onBackClick() {
        print("Clicked back")
        self.navigationController?.popViewController(animated: true)
    }
    
}
