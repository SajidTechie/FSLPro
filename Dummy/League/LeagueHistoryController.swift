//
//  LeagueHistoryController.swift
//  Dummy
//
//  Created by Goldmedal on 12/03/22.
//

import UIKit

class LeagueHistoryController: UIViewController{
    @IBOutlet weak var header : HeaderWithScore!
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var tableView : UITableView!
    public var teamRank: [TeamRank] = []
    
    public var mid = Int()
    public var lid = Int()
    var model: Match?
    
    private var presenter: iMatchesPresenter!
    private var rules: [GetRulesData] = []
    private var liveScoreObj: [LiveScoreData] = []
    var callFromScreen = String()
    
    weak var timer: Timer?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            refreshControl.endRefreshing()
            
            if(self.callFromScreen.elementsEqual("LIVE")){
                self.presenter.getLiveScore(mid: self.mid,position:-1, callFrom: Constant.LIVE_SCORE)
                
                if(self.timer == nil){
                    self.timer = Timer.scheduledTimer(timeInterval: Constant.LIVE_REFRESH_RATE,
                                                      target: self,
                                                      selector: #selector(self.update),
                                                      userInfo: nil,
                                                      repeats: true)
                }
            }else{
                self.presenter.getLiveScore(mid: self.mid,position:-1, callFrom: Constant.LIVE_SCORE)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        header.delegate = self
        
        presenter = MatchesPresenter(view: self)
        presenter.initInteractor()
        presenter.getRules(callFrom: Constant.RULES)
        
        if(callFromScreen.elementsEqual("LIVE")){
            presenter.getLiveScore(mid: mid,position:-1, callFrom: Constant.LIVE_SCORE)
            
            if(timer == nil){
                timer = Timer.scheduledTimer(timeInterval: Constant.LIVE_REFRESH_RATE,
                                             target: self,
                                             selector: #selector(self.update),
                                             userInfo: nil,
                                             repeats: true)
            }
        }else{
            presenter.getLiveScore(mid: mid,position:-1, callFrom: Constant.LIVE_SCORE)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
    }
    
    
    @IBAction func clickScorecard(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
        let vcLeague = storyBoard.instantiateViewController(withIdentifier: "CompletedMatchDetailController") as! CompletedMatchDetailController
        vcLeague.mid = mid
        vcLeague.callFromScreen = "COMPLETED"
        self.navigationController!.pushViewController(vcLeague, animated: true)
    }
    
    //    deinit{
    //        print("** ** ** denit LeagueHistoryController ** ** **")
    //        NotificationCenter.default.removeObserver(self)
    //        timer?.invalidate()
    //    }
    
    
    @objc func update() {
        // do what should happen when timer triggers an event
        print("** ** ** LeagueHistoryController ** ** **")
        presenter.getLiveScore(mid: mid,position:-1, callFrom: Constant.LIVE_SCORE)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("** ** ** denit LeagueHistoryController ** ** **")
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
    }
    
    
}


extension LeagueHistoryController : MatchesPresentable {
    func willLoadData(callFrom:String) {
        noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom.elementsEqual(Constant.RULES))
        {
            rules = presenter.rules
            print("** ** rules ** ** - - - ",rules)
            
            if(rules.count > 0)
            {
                let userName = rules[0].bal?.dN ?? "-"
                let walletBalance = String(rules[0].bal?.bAL ?? 0)
                let referralCode = rules[0].bal?.refCode ?? "-"
                
                UserDefaults.standard.set(userName, forKey: "UserName")
                UserDefaults.standard.set(walletBalance, forKey: "WalletBalance")
                UserDefaults.standard.set(referralCode, forKey: "ReferralCode")
            }
           
        }
        
        if(callFrom.elementsEqual(Constant.LIVE_SCORE)){
            liveScoreObj = presenter.liveScore
            
            if(liveScoreObj.count > 0){
                header.bindHeaderForLiveMatch(model: model,score: liveScoreObj[0], strResult: "")
            }
           
        }
        noDataView.hideView(view: noDataView)
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getRules(callFrom: Constant.RULES)
        }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension LeagueHistoryController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teamRank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let type = teamRank[indexPath.row].ltype ?? 1
        
        switch type
        {
        case Constant.NORMAL_LEAGUE_TYPE:
            
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
           
            normalCell.lblLeagueName.text = teamRank[indexPath.row].LName
            normalCell.lblWinningAmnt.text =  Utility.currencyFormat(amount: teamRank[indexPath.row].Winning ?? 0.0)//String(teamRank[indexPath.row].Winning ?? 0.0)
            
            let entriesSize = teamRank[indexPath.row].LMaxSize ?? 0
            let entriesJoined = teamRank[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            normalCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize) LEFT"
            
            if (entriesSize > 0) {
                normalCell.vwProgress.setProgress(Float(Float(entriesJoined)/Float(entriesSize)), animated: true)
            }else{
                normalCell.vwProgress.setProgress(Float(0), animated: true)
            }
            
            if (teamRank[indexPath.row].Status == 2) {
                normalCell.btnEntryFees.setTitle(StringConstants.str_refunded, for: .normal)
            }else{
                normalCell.btnEntryFees.setTitle(StringConstants.str_details, for: .normal)
            }
            
            normalCell.delegate = self
            return normalCell
            break
            
        case Constant.UNLIMITED_LEAGUE_TYPE:
            
            let unlimitedCell = tableView.dequeueReusableCell(withIdentifier: "UnlimitedLeagueCell", for: indexPath) as! UnlimitedLeagueCell
            
            
            unlimitedCell.lblLeagueName.text = teamRank[indexPath.row].LName?.uppercased()
            unlimitedCell.lblWinningAmnt.text = Utility.currencyFormat(amount:teamRank[indexPath.row].Winning ?? 0.0)
            
            if ((teamRank[indexPath.row].awards?.isEmpty) == false) {
                if ((teamRank[indexPath.row].awards?[0].a?.isEmpty) == false) {
                    print("imvPrize.isHidden = false")
                    unlimitedCell.imvPrize.isHidden = false
                    unlimitedCell.imvPrize.sd_setImage(with: URL(string: Constant.WEBSITE_URL + ("/\(teamRank[indexPath.row].awards?[0].a?[0].img ?? "")").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: ""))
               }else{
                   print("imvPrize.isHidden")
                   unlimitedCell.imvPrize.isHidden = true
                }
            }else{
                print("imvPrize.isHidden = true")
                unlimitedCell.imvPrize.isHidden = true
            }
            
            let entriesSize = teamRank[indexPath.row].LMaxSize ?? 0
            let entriesJoined = teamRank[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            unlimitedCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize)"
            
            if (entriesSize > 0) {
                unlimitedCell.vwProgress.setProgress(Float(entriesJoined/entriesSize), animated: true)
            }else{
                unlimitedCell.vwProgress.setProgress(Float(0), animated: true)
            }
            
            if (teamRank[indexPath.row].Status == 2) {
                unlimitedCell.btnEntryFees.setTitle(StringConstants.str_refunded, for: .normal)
            }else{
                unlimitedCell.btnEntryFees.setTitle(StringConstants.str_details, for: .normal)
            }
            
            unlimitedCell.delegate = self
            return unlimitedCell
            break
            
        case Constant.SPONSOR_LEAGUE_TYPE:
            
            let sponsorCell = tableView.dequeueReusableCell(withIdentifier: "SpecialLeagueCell", for: indexPath) as! SpecialLeagueCell
            
            sponsorCell.btnEntryFees.setTitle(Utility.currencyFormat(amount:teamRank[indexPath.row].fees ?? 0.0), for: .normal)
            sponsorCell.lblLeagueName.text = teamRank[indexPath.row].LName
            
            let entriesSize = teamRank[indexPath.row].LMaxSize ?? 0
            let entriesJoined = teamRank[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            sponsorCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize)"
            
            sponsorCell.delegate = self
            return sponsorCell
            break
            
        default:
            return UITableViewCell()
            break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func leagueForMatchTransform(teamRank:TeamRank?)->LeagueDetailData?{
        let leagueObj = LeagueDetailData(lgID: teamRank?.id, lmid: nil, ltype: teamRank?.ltype, winningAmt: teamRank?.Winning, lMaxSize: teamRank?.LMaxSize, lCurSize: teamRank?.LCurSize, isOpen: nil, lName: teamRank?.LName, lDesc: nil, lMinEntries: nil, isElastic: nil, lEntryFees: nil, lWinner: nil, wData: teamRank?.wData, j: nil, awards: teamRank?.awards)
        return leagueObj
    }
    
}

extension LeagueHistoryController : LeaguesDelegate {
    func showInfo(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        
//        if(position != -1){
//            let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
//            let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "LeagueInfoViewPopup") as! LeagueInfoViewPopup
//            vcLeagueInfo.leagueForMatch = leagueForMatchTransform(teamRank: teamRank[position])
//            self.present(vcLeagueInfo, animated: false)
//        }
        if(position != -1){
            if(teamRank[position].ltype == Constant.NORMAL_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "LeagueInfoViewPopup") as! LeagueInfoViewPopup
                vcLeagueInfo.leagueForMatch = leagueForMatchTransform(teamRank: teamRank[position])
                self.present(vcLeagueInfo, animated: false)
            }
         
            if(teamRank[position].ltype == Constant.UNLIMITED_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "JumboLeagueInfoPopup") as! JumboLeagueInfoPopup
                vcLeagueInfo.leagueForMatch = leagueForMatchTransform(teamRank: teamRank[position])
                self.present(vcLeagueInfo, animated: false)
            }
            
            if(teamRank[position].ltype == Constant.SPONSOR_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "JumboLeagueInfoPopup") as! JumboLeagueInfoPopup
                vcLeagueInfo.leagueForMatch = leagueForMatchTransform(teamRank: teamRank[position])
                self.present(vcLeagueInfo, animated: false)
            }
        }
        
    }
    
    func joinLeague(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        
        if(position != -1){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
            let vcLeaderBoardScorecard = storyBoard.instantiateViewController(withIdentifier: "LeaderBoardScorecardController") as! LeaderBoardScorecardController
            vcLeaderBoardScorecard.callFromScreen = callFromScreen
            vcLeaderBoardScorecard.model = model
            vcLeaderBoardScorecard.teamRank = teamRank[position]
            self.present(vcLeaderBoardScorecard, animated: true)
        }
        
    }
    
    
}

extension LeagueHistoryController:HandleHeaderBack{
    func onBackClick() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func onAboutMatch() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
        let vcAboutMatch = storyBoard.instantiateViewController(withIdentifier: "AboutMatchController") as! AboutMatchController
        vcAboutMatch.mid = mid
        vcAboutMatch.model = model
        vcAboutMatch.callFrom = "HISTORY"
        self.present(vcAboutMatch, animated: true)
    }
    
}
