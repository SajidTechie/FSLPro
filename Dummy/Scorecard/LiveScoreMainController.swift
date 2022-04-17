//
//  LiveScoreMainController.swift
//  Dummy
//
//  Created by Goldmedal on 06/10/21.
//

import UIKit


class LiveScoreMainController: UIViewController {
    
    var mid = Int()

    private var presenter: iScorecardListPresenter!
    private var scorecard: [ScorecardMain] = []
    
    weak var timer: Timer?
 
    var callFrom = "LIVE"
    
    var tabs = [
        ViewPagerTab(title: "LIVE SCORE", image: UIImage(named: "")),
        ViewPagerTab(title: "SCORECARD", image: UIImage(named: "")),
        ViewPagerTab(title: "ABOUT MATCH", image: UIImage(named: ""))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ScorecardListPresenter(view: self)
        presenter.initInteractor()
        
        if(timer == nil){
        timer = Timer.scheduledTimer(timeInterval: Constant.LIVE_REFRESH_RATE,
                             target: self,
                             selector: #selector(self.update),
                             userInfo: nil,
                             repeats: true)
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("** ** ** deinit LiveScoreMainController ** ** **")
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    // @objc selector expected for Timer
    @objc func update() {
        // do what should happen when timer triggers an event
        print("** ** ** LiveScoreMainController ** ** **")
        presenter.getScorecard(mid: mid, callFrom: Constant.SCORECARD)
        
    }
    
    
}

extension LiveScoreMainController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
        self.view.activityStartAnimating()
    }
    
    func didLoadData(callFrom:String){
        
        scorecard = presenter.scorecard
        
        print("scorecard - - - ",scorecard)
        let scorecardDataDict:[String: [ScorecardMain]] = ["scorecard": scorecard]
        NotificationCenter.default.post(name: NSNotification.Name("LIVE_SCORE"), object: nil, userInfo: scorecardDataDict)
        self.view.activityStopAnimating()
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getScorecard(mid: mid, callFrom: Constant.SCORECARD)
        }
        self.view.activityStopAnimating()
    }
}

/*
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
 */
