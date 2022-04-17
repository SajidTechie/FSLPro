//
//  CompletedTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit
import XLPagerTabStrip

class CompletedTabController: UIViewController,IndicatorInfoProvider  {
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noDataView : NoDataView!
    private var presenter: iMatchesPresenter!
    private var matchesList: [Match] = []
    private var myTeamRank: [TeamRank] = []
    var model : Match?
    
    var mid = Int()
    var itemInfo: IndicatorInfo = "COMPLETED"
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
            self.presenter.getMatches(mid: 2, callFrom: Constant.UPCOMING_MATCHES)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
        
        
        presenter = MatchesPresenter(view: self)
        presenter.initInteractor()
        presenter.getMatches(mid: 2, callFrom: Constant.UPCOMING_MATCHES)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
      
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
}



extension CompletedTabController : MatchesPresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.UPCOMING_MATCHES){
        matchesList = presenter.matches
        print("** ** completed matches ** ** - - - ",matchesList)
            if(matchesList.count > 0){
                noDataView.hideView(view: noDataView)
                self.tableView.reloadData()
            }else{
                noDataView.showView(view: self.noDataView, from: "", msg: "")
            }
       
        }
        
        if(callFrom == Constant.MY_TEAM_RANK){
            
            myTeamRank = presenter.myTeamRank
            
            if(myTeamRank.count > 0){

                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueHistory = storyBoard.instantiateViewController(withIdentifier: "LeagueHistoryController") as! LeagueHistoryController
                vcLeagueHistory.mid = mid
                vcLeagueHistory.model = model
                vcLeagueHistory.teamRank = myTeamRank
                self.navigationController!.pushViewController(vcLeagueHistory, animated: true)
        
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
                let vcLeague = storyBoard.instantiateViewController(withIdentifier: "CompletedMatchDetailController") as! CompletedMatchDetailController
                vcLeague.mid = mid
                vcLeague.callFromScreen = "COMPLETED"
                self.navigationController!.pushViewController(vcLeague, animated: true)
      
            }
            
            print("** ** myTeamRank data ** ** - - - ",myTeamRank)
            
        }
        
      
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getMatches(mid: 2, callFrom: Constant.UPCOMING_MATCHES)
       }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension CompletedTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedViewCell", for: indexPath) as! CompletedViewCell
        cell.lblTeamA.text = matchesList[indexPath.row].teamA ?? ""
        cell.lblTeamB.text = matchesList[indexPath.row].teamB ?? ""
        cell.lblLeague.text = matchesList[indexPath.row].season
        cell.lblMatch.text = matchesList[indexPath.row].groupName
        cell.lblResult.text = matchesList[indexPath.row].note
        
        cell.imvTeamALogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamALogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        cell.imvTeamBLogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamBLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        
        if(matchesList[indexPath.row].teamAScore?.contains(",") == true){
            let teamA = matchesList[indexPath.row].teamAScore?.split(separator: ",")
            if(teamA?.count ?? 0 > 0){
                cell.lblTeamAScore1.text = String(teamA?[0] ?? "")
                cell.lblTeamAScore2.text = String(teamA?[1] ?? "")
            }else{
                cell.lblTeamAScore1.text = matchesList[indexPath.row].teamAScore
                cell.lblTeamAScore2.text =  ""
            }
        }else{
            cell.lblTeamAScore1.text = matchesList[indexPath.row].teamAScore
            cell.lblTeamAScore2.text =  ""
        }
        
        if(matchesList[indexPath.row].teamBScore?.contains(",") == true){
            let teamB = matchesList[indexPath.row].teamBScore?.split(separator: ",")
            if(teamB?.count ?? 0 > 0){
                cell.lblTeamBScore1.text = String(teamB?[0] ?? "")
                cell.lblTeamBScore2.text = String(teamB?[1] ?? "")
            }else{
                cell.lblTeamBScore1.text = matchesList[indexPath.row].teamBScore
                cell.lblTeamBScore2.text = ""
            }
        }else{
            cell.lblTeamBScore1.text = matchesList[indexPath.row].teamBScore
            cell.lblTeamBScore2.text = ""
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CompletedViewCell
        
        mid = self.matchesList[indexPath.row].mID ?? 0
        presenter.getTeamRank(mid: mid,callFrom: Constant.MY_TEAM_RANK)
        model = self.matchesList[indexPath.row]
        
    }
    
}

