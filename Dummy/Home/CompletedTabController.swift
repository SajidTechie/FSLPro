//
//  CompletedTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class CompletedTabController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iMatchesPresenter!
    private var matchesList: [Match] = []
    private var myTeamRank: [TeamRankData] = []
    
    var mid = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        presenter = MatchesPresenter(view: self)
        presenter.initInteractor()
        presenter.getMatches(mid: 2, callFrom: Constant.UPCOMING_MATCHES)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    
}



extension CompletedTabController : MatchesPresentable {
    func willLoadData(callFrom:String) {
    
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.UPCOMING_MATCHES){
        matchesList = presenter.matches
        print("** ** completed matches ** ** - - - ",matchesList)
        self.tableView.reloadData()
        }
        
        if(callFrom == Constant.MY_TEAM_RANK){
            
            myTeamRank = presenter.myTeamRank
            
            if(myTeamRank.count > 0){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeague = storyBoard.instantiateViewController(withIdentifier: "LeagueDetailViewController") as! LeagueDetailViewController
                vcLeague.mid = mid
                vcLeague.myTeamRank = myTeamRank
                self.navigationController!.pushViewController(vcLeague, animated: true)
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
                let vcLeague = storyBoard.instantiateViewController(withIdentifier: "CompletedMatchDetailController") as! CompletedMatchDetailController
                vcLeague.mid = mid
                self.navigationController!.pushViewController(vcLeague, animated: true)
            }
            
            print("** ** myTeamRank data ** ** - - - ",myTeamRank)
            
        }
       
    }
    
    func didFail(error: CustomError,callFrom:String) {
   
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
        
        cell.imvTeamALogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamALogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        cell.imvTeamBLogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamBLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        
        if(matchesList[indexPath.row].teamAScore?.contains(",") == true){
            let teamA = matchesList[indexPath.row].teamAScore?.split(separator: ",")
            if(teamA?.count ?? 0 > 0){
                cell.lblTeamAScore1.text = String(teamA?[0] ?? "-")
                cell.lblTeamAScore2.text = String(teamA?[1] ?? "-")
            }else{
                cell.lblTeamAScore1.text = matchesList[indexPath.row].teamAScore
            }
        }else{
            cell.lblTeamAScore1.text = matchesList[indexPath.row].teamAScore
        }
        
        if(matchesList[indexPath.row].teamBScore?.contains(",") == true){
            let teamB = matchesList[indexPath.row].teamBScore?.split(separator: ",")
            if(teamB?.count ?? 0 > 0){
                cell.lblTeamBScore1.text = String(teamB?[0] ?? "-")
                cell.lblTeamBScore2.text = String(teamB?[1] ?? "-")
            }else{
                cell.lblTeamBScore1.text = matchesList[indexPath.row].teamBScore
            }
        }else{
            cell.lblTeamBScore1.text = matchesList[indexPath.row].teamBScore
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CompletedViewCell
        
        mid = self.matchesList[indexPath.row].mID ?? 0
        presenter.getTeamRank(mid: mid,callFrom: Constant.MY_TEAM_RANK)
        
    }
    
}

