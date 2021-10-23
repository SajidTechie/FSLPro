//
//  AboutMatchController.swift
//  Dummy
//
//  Created by Goldmedal on 30/09/21.
//

import UIKit

class AboutMatchController: UIViewController {
    
    @IBOutlet weak var lblToss : UILabel!
    @IBOutlet weak var lblMatch : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblVenue : UILabel!
    @IBOutlet weak var lblSeries : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblUmpire : UILabel!
    @IBOutlet weak var lbl3rdUmpire : UILabel!
    @IBOutlet weak var lblReferee : UILabel!
    
    private var presenter: iScorecardListPresenter!
    private var matchInfo: MatchInfo? = nil
    
    var callFrom = ""
    public var mid = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if(callFrom.elementsEqual("LIVE")){
            NotificationCenter.default.addObserver(self, selector: #selector(liveScoreUpdate(_:)), name: NSNotification.Name("LIVE_SCORE"), object: nil)
        }else{
            presenter = ScorecardListPresenter(view: self)
            presenter.initInteractor()
            presenter.getMatchInfo(mid: mid, callFrom: Constant.ABOUT_MATCH)
        }
        
    }
    
    
    @objc func liveScoreUpdate(_ notification:Notification){
        
        let scorecardObj = notification.userInfo as! Dictionary<String,AnyObject>
        
        let scorecard = scorecardObj["scorecard"] as? [ScorecardMain] ?? []
        print("LIVE SCORECARD - - - - - ",scorecard)
        
        if(scorecard.count > 0){
            matchInfo = scorecard[0].info
        }
        
        if(matchInfo != nil){
            setData()
        }
        
    }
    
    
    func setData(){
        
        if (matchInfo?.toss?.elected != nil) {
            lblToss.text = "\(matchInfo?.toss?.team ?? "")  \(matchInfo?.toss?.elected ?? "") first"
        }else{
            lblToss.text = matchInfo?.toss?.team
        }
        
        lblDate.text = matchInfo?.utc ?? ""
        lbl3rdUmpire.text = matchInfo?.tvUmpire?.full
        lblMatch.text = matchInfo?.grp
        lblSeries.text = matchInfo?.ty
        lblTime.text = matchInfo?.utc ?? ""
        lblVenue.text = matchInfo?.venue?.name
        if ((matchInfo?.secondUmpire?.full == nil) || (matchInfo?.secondUmpire?.full?.isEmpty == true)) {
            lblUmpire.text = matchInfo?.firstUmpire?.full
        } else {
            lblUmpire.text = "\(matchInfo?.firstUmpire?.full ?? "") & \(matchInfo?.secondUmpire?.full ?? "")"
        }
        
        
        lblReferee.text = matchInfo?.referee?.full
        
    }
}


extension AboutMatchController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
        let matchData = presenter.matchInfo
        
        
        if(matchData.count > 0){
            matchInfo = matchData[0].info
            if(matchInfo != nil){
                setData()
            }
        }
        
        print("matchInfo - - - ",matchInfo)
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}
