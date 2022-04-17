//
//  LeaderBoardScorecardController.swift
//  Dummy
//
//  Created by Goldmedal on 13/03/22.
//

import UIKit

class LeaderBoardScorecardController: UIViewController {
    
    @IBOutlet weak var vwMain : UIView!
    @IBOutlet weak var header : HeaderWithScore!
    @IBOutlet weak var btnLeaderBoard : GradientButton!
    @IBOutlet weak var btnScorecard : GradientButton!
    
    var teamRank: TeamRank? = nil
    var model: Match?
    var callFromScreen = String()
    
    private var presenter: iScorecardListPresenter!
    var scorecard: [ScorecardMain] = []
    
    var tabs = [ViewPagerTab]()
    var pager:ViewPager?
    let options = ViewPagerOptions()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegate = self
        
        // Do any additional setup after loading the view.
        presenter = ScorecardListPresenter(view: self)
        presenter.initInteractor()
        presenter.getScorecard(mid: model?.mID ?? 0,callFrom: Constant.SCORECARD)
        
        toggleBtn(state: 0)
        
        tabs = [
           ViewPagerTab(title: "", image: UIImage(named: "")),
           ViewPagerTab(title: "", image: UIImage(named: ""))
       ]
        
       
   
        // - - - - To hide paging tabs - - - -
       options.tabIndicatorViewHeight = 0
       options.tabViewHeight = 0
        
        pager = ViewPager(viewController: self, containerView: self.vwMain)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func clickLeaderboard(_ sender: UIButton) {
        toggleBtn(state: 0)
        pager?.displayViewController(atIndex: 0)
    }
    
    @IBAction func clickScorecard(_ sender: UIButton) {
        toggleBtn(state: 1)
        pager?.displayViewController(atIndex: 1)
    }
    
    
    func toggleBtn(state:Int){
        // 0 - - - -leaderboard
        //1 - - - - scorecard
        if(state == 0){
            btnScorecard.startColor = UIColor.init(named: "deselectedTabGray") ?? .lightGray
            btnScorecard.endColor = UIColor.init(named: "deselectedTabGray") ?? .lightGray
            btnScorecard.borderColor = UIColor.init(named: "deselectedTabGray") ?? .lightGray
            
            btnLeaderBoard.startColor = UIColor.init(named: "buttonBottom") ?? .red
            btnLeaderBoard.endColor = UIColor.init(named: "buttonTop") ?? .red
            btnLeaderBoard.borderColor = UIColor.init(named: "bottomRed") ?? .red
          
        }else{
            btnLeaderBoard.startColor = UIColor.init(named: "deselectedTabGray") ?? .lightGray
            btnLeaderBoard.endColor = UIColor.init(named: "deselectedTabGray") ?? .lightGray
            btnLeaderBoard.borderColor = UIColor.init(named: "deselectedTabGray") ?? .lightGray
            
            btnScorecard.startColor = UIColor.init(named: "buttonBottom") ?? .red
            btnScorecard.endColor = UIColor.init(named: "buttonTop") ?? .red
            btnScorecard.borderColor = UIColor.init(named: "bottomRed") ?? .red
        }
        
        btnScorecard.updateColors()
        btnLeaderBoard.updateColors()
        
       
    }
   
}


extension LeaderBoardScorecardController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
         
    }
    
    func didLoadData(callFrom:String){
        
        scorecard = presenter.scorecard
        print("scorecard - - - ",scorecard)
        
        if(scorecard.count > 0){
            header.bindHeader(model: model, strResult: scorecard[0].info?.res ?? "-")
        }
    
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
    }
}


extension LeaderBoardScorecardController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        var vc = UIViewController()
    
            if position == 0
           {
               let teamStoryBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
               vc = teamStoryBoard.instantiateViewController(withIdentifier: "LeaderboardRankController") as! LeaderboardRankController
               let vcLeaderBoardRank = vc as! LeaderboardRankController
                vcLeaderBoardRank.model = model
                vcLeaderBoardRank.lid = teamRank?.id ?? -1
                vcLeaderBoardRank.callFromScreen = callFromScreen
           }
           else if position == 1
           {
               let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
               vc = storyBoard.instantiateViewController(withIdentifier: "ScorecardViewController") as! ScorecardViewController
               let vcFullScorecard = vc as! ScorecardViewController
               vcFullScorecard.mid = model?.mID ?? -1
               vcFullScorecard.callFrom = callFromScreen
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

extension LeaderBoardScorecardController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
        toggleBtn(state: index)
    }
    
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}



extension LeaderBoardScorecardController:HandleHeaderBack{
    func onBackClick() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func onAboutMatch() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
        let vcAboutMatch = storyBoard.instantiateViewController(withIdentifier: "AboutMatchController") as! AboutMatchController
        vcAboutMatch.mid = model?.mID ?? -1
        vcAboutMatch.callFrom = "HISTORY"
        vcAboutMatch.model = model
        self.present(vcAboutMatch, animated: true)
    }
    
}
