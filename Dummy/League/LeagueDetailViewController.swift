//
//  LeagueDetailViewController.swift
//  Dummy
//
//  Created by Goldmedal on 29/10/21.
//

import UIKit

class LeagueDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var myTeamRank: [TeamRankData] = []
    var mid = Int()
    var lid = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(myTeamRank.count > 0){
            lid = myTeamRank[0].id ?? 0
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.reloadData()
      
    }
    
    
}



extension LeagueDetailViewController : LeaguePresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
       
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


extension LeagueDetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myTeamRank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailCell", for: indexPath) as! LeagueDetailCell
        cell.lblPrice.text = String(myTeamRank[indexPath.row].fees ?? 0.0)
        cell.lblPeople.text = myTeamRank[indexPath.row].lName
        
        if (myTeamRank[indexPath.row].status == 2) {
            cell.lblStatus.text = "Refunded"
        }else{
            cell.lblStatus.text = "Details"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
}

extension LeagueDetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = indexPath.row
        
        if(position != -1){
           print("Leaderboard main")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
            let vcLeaderBoard = storyBoard.instantiateViewController(withIdentifier: "LeaderboardDetailController") as! LeaderboardDetailController
            vcLeaderBoard.mid = mid
            vcLeaderBoard.lid = lid
            self.navigationController!.pushViewController(vcLeaderBoard, animated: true)
            
        }
    }
}




