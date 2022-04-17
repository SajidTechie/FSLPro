//
//  AboutMatchController.swift
//  Dummy
//
//  Created by Goldmedal on 30/09/21.
//

import UIKit

class AboutMatchController: UIViewController {
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var scrollMain : UIScrollView!
    @IBOutlet weak var lblToss : UILabel!
    @IBOutlet weak var lblMatch : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblVenue : UILabel!
    @IBOutlet weak var lblSeries : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblUmpire : UILabel!
    @IBOutlet weak var lbl3rdUmpire : UILabel!
    @IBOutlet weak var lblReferee : UILabel!
    @IBOutlet weak var header : Header!
    
    private var presenter: iScorecardListPresenter!
    private var matchInfo: MatchInfo? = nil
    
    var callFrom = ""
    public var mid = Int()
    var model : Match?
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        refreshControl.endRefreshing()
            if(self.callFrom.elementsEqual("LIVE")){
            print("Call from live and no api is called")
        }else{
            self.presenter.getMatchInfo(mid: self.mid, callFrom: Constant.ABOUT_MATCH)
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 10.0, *){
            scrollMain.refreshControl = refreshControl
        }else{
            scrollMain.addSubview(refreshControl)
        }
        
        header.delegate = self
        header.bindData(strTitle: model?.matchName ?? "-")
        
        // Do any additional setup after loading the view.
        if(callFrom.elementsEqual("LIVE")){
            NotificationCenter.default.addObserver(self, selector: #selector(liveScoreUpdate(_:)), name: NSNotification.Name("LIVE_SCORE"), object: nil)
        }else{
            presenter = ScorecardListPresenter(view: self)
            presenter.initInteractor()
            presenter.getMatchInfo(mid: mid, callFrom: Constant.ABOUT_MATCH)
        }
        
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
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
            lblToss.text = "\(matchInfo?.toss?.team ?? "")  \(matchInfo?.toss?.elected ?? "")"
        }else{
            lblToss.text = matchInfo?.toss?.team
        }
        
        lblDate.text = Utility.formattedDateWithOtherFormat(dateString: matchInfo?.utc ?? "", givenFormat: "yyyy-MM-dd'T'HH:mm:ssZ", withFormat: "EEE, dd MMM yyyy")//Utility.UTCToLocal(utcTime: matchInfo?.utc ?? "", outputFormat: "dd-MM-yyyy")
        lbl3rdUmpire.text = matchInfo?.tvUmpire?.full
        lblMatch.text = matchInfo?.grp
        lblSeries.text = matchInfo?.ty
        lblTime.text = Utility.formattedDateWithOtherFormat(dateString: matchInfo?.utc ?? "", givenFormat: "yyyy-MM-dd'T'HH:mm:ssZ", withFormat: "h:mm a")
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
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        let matchData = presenter.matchInfo
        
        if(matchData.count > 0){
            matchInfo = matchData[0].info
            if(matchInfo != nil){
                setData()
            }
        }
       noDataView.hideView(view: noDataView)
        print("matchInfo - - - ",matchInfo)
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getMatchInfo(mid: mid, callFrom: Constant.ABOUT_MATCH)
       }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension AboutMatchController:HandleHeaderBack{
    func onBackClick() {
        self.dismiss(animated: true, completion: nil)
    }
}
