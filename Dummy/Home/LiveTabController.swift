//
//  LiveTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit
import XLPagerTabStrip

class LiveTabController: UIViewController,IndicatorInfoProvider   {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noDataView : NoDataView!
    private var presenter: iMatchesPresenter!
    private var matchesList: [Match] = []
    private var liveScoreObj: [LiveScoreData] = []
    private var liveScoreMainArr: [LiveScoreData] = []
    private var myTeamRank: [TeamRank] = []
    weak var timer: Timer?
    
    var model : Match?
    var mid = Int()
    
    var callLiveMatch = false
    var itemInfo: IndicatorInfo = "LIVE"
    var pagerStrip = PagerTabStripViewController()
    
    // MARK: - XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        pagerStrip = pagerTabStripController
        return itemInfo
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            refreshControl.endRefreshing()
            self.presenter.getMatches(mid: 1, callFrom: Constant.UPCOMING_MATCHES)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Constant.LIVE_REFRESH_RATE,
                                         target: self,
                                         selector: #selector(self.update),
                                         userInfo: nil,
                                         repeats: true)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("** ** ** deinit LiveTabController ** ** ** ")
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter = MatchesPresenter(view: self)
        presenter.initInteractor()
        presenter.getMatches(mid: 1, callFrom: Constant.UPCOMING_MATCHES)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // @objc selector expected for Timer
    @objc func update() {
        // do what should happen when timer triggers an event
        print("** ** ** LiveTabController ** ** ** ")
        updateLiveScoreApi()
        
    }
    
    
    func updateLiveScoreApi(){
        if(matchesList.count > 0){
            //  liveScoreMainArr.removeAll()
            for i in 0...(matchesList.count - 1) {
                presenter.getLiveScore(mid: matchesList[i].mID ?? 0,position:i, callFrom: Constant.LIVE_SCORE)
            }
            
            callLiveMatch = true
        }
    }
    
    
}



extension LiveTabController : MatchesPresentable {
    func willLoadData(callFrom:String) {
        noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        if(callFrom == Constant.UPCOMING_MATCHES || callFrom == Constant.LIVE_SCORE)
        {
            
            if(callLiveMatch == false)
            {
                matchesList = presenter.matches
                
                if(matchesList.count > 0){
                    for i in 0...(matchesList.count - 1) {
                        
                        liveScoreMainArr.insert(LiveScoreData(groupName: matchesList[i].groupName ?? "-", matchDate: matchesList[i].matchDate ?? "-", matchName: matchesList[i].matchName ?? "-", mID: matchesList[i].mID ?? 0, position:i, season: matchesList[i].season ?? "-", status: matchesList[i].status ?? 0, teamA: matchesList[i].teamA ?? "-", teamALogo: matchesList[i].teamALogo ?? "-", teamB: matchesList[i].teamB ?? "-", teamBLogo: matchesList[i].teamBLogo ?? "-",teamAScore: matchesList[i].teamAScore ?? "-",teamBScore: matchesList[i].teamBScore ?? "-",venue: matchesList[i].venue ?? "-"), at: i)
                    }
                }
       
            }
            
            
            if(callLiveMatch == true)
            {
                liveScoreObj = presenter.liveScore
                
                let position = presenter.liveMatchesPosition
                if(liveScoreObj.count > 0){
                    liveScoreObj[0].position = position
                    liveScoreMainArr[position].teamAScore = liveScoreObj[0].teamAScore
                    liveScoreMainArr[position].teamBScore = liveScoreObj[0].teamBScore
                    
                    liveScoreMainArr.sorted(by: { $0.position < $1.position })
                    
                }
                
            }
            
            print("** ** live matches ** ** - - - ",matchesList)
            print("** ** liveScoreMainArr** ** - - - ",liveScoreMainArr)
            
            if (liveScoreMainArr.count > 0){
                self.tableView.reloadData()
                noDataView.hideView(view: self.noDataView)
            }else{
                noDataView.showView(view: self.noDataView, from: "", msg: StringConstants.no_live_matches)
            }
            
        }
        
        
        if(callFrom == Constant.MY_TEAM_RANK){
            
            myTeamRank = presenter.myTeamRank
            //TODO
            if(myTeamRank.count > 0){
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueHistory = storyBoard.instantiateViewController(withIdentifier: "LeagueHistoryController") as! LeagueHistoryController
                vcLeagueHistory.mid = mid
                vcLeagueHistory.model = model
                vcLeagueHistory.teamRank = myTeamRank
                vcLeagueHistory.callFromScreen = "LIVE"
                self.navigationController!.pushViewController(vcLeagueHistory, animated: true)
                
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
                let vcLeague = storyBoard.instantiateViewController(withIdentifier: "CompletedMatchDetailController") as! CompletedMatchDetailController
                vcLeague.mid = mid
                vcLeague.callFromScreen = "LIVE"
                self.navigationController!.pushViewController(vcLeague, animated: true)
                
            }
            
            print("** ** myTeamRank data ** ** - - - ",myTeamRank)
          //  noDataView.hideView(view: noDataView)
        }
        
    }
    
    
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getMatches(mid: 1, callFrom: Constant.UPCOMING_MATCHES)
        }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension LiveTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedViewCell", for: indexPath) as! CompletedViewCell
        cell.lblTeamA.text = liveScoreMainArr[indexPath.row].teamA ?? ""
        cell.lblTeamB.text = liveScoreMainArr[indexPath.row].teamB ?? ""
        cell.lblLeague.text = liveScoreMainArr[indexPath.row].season
        cell.lblMatch.text = liveScoreMainArr[indexPath.row].groupName
        
        cell.imvTeamALogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (liveScoreMainArr[indexPath.row].teamALogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        cell.imvTeamBLogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (liveScoreMainArr[indexPath.row].teamBLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        
        if(liveScoreMainArr[indexPath.row].teamAScore?.contains(",") == true){
            let teamA = liveScoreMainArr[indexPath.row].teamAScore?.split(separator: ",")
            if(teamA?.count ?? 0 > 0){
                cell.lblTeamAScore1.text = String(teamA?[0] ?? "-")
                cell.lblTeamAScore2.text = String(teamA?[1] ?? "-")
            }else{
                cell.lblTeamAScore1.text = liveScoreMainArr[indexPath.row].teamAScore
                cell.lblTeamAScore2.text =  ""
            }
        }else{
            cell.lblTeamAScore1.text = liveScoreMainArr[indexPath.row].teamAScore
            cell.lblTeamAScore2.text =  ""
        }
        
        if(liveScoreMainArr[indexPath.row].teamBScore?.contains(",") == true){
            let teamB = liveScoreMainArr[indexPath.row].teamBScore?.split(separator: ",")
            if(teamB?.count ?? 0 > 0){
                cell.lblTeamBScore1.text = String(teamB?[0] ?? "-")
                cell.lblTeamBScore2.text = String(teamB?[1] ?? "-")
            }else{
                cell.lblTeamBScore1.text = liveScoreMainArr[indexPath.row].teamBScore
                cell.lblTeamBScore2.text =  ""
            }
        }else{
            cell.lblTeamBScore1.text = liveScoreMainArr[indexPath.row].teamBScore
            cell.lblTeamBScore2.text =  ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mid = self.matchesList[indexPath.row].mID ?? 0
        presenter.getTeamRank(mid: mid,callFrom: Constant.MY_TEAM_RANK)
        model = self.matchesList[indexPath.row]
        
        // call api for team rank
        //  leaguesViewModel.getTeamRank(mid)
        
        
    }
    
}
