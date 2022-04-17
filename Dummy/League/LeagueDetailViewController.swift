//
//  LeagueDetailViewController.swift
//  Dummy
//
//  Created by Goldmedal on 29/10/21.
//

import UIKit

class LeagueDetailViewController: UIViewController {
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var tableView : UITableView!
    var myTeamRank: [TeamRank] = []
    var mid = Int()
    var lid = Int()
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(myTeamRank.count > 0){
            lid = myTeamRank[0].id ?? 0
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        tableView.reloadData()
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
      
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
}




extension LeagueDetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myTeamRank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueDetailCell", for: indexPath) as! LeagueDetailCell
        cell.lblPrice.text = String(myTeamRank[indexPath.row].fees ?? 0.0)
        cell.lblPeople.text = myTeamRank[indexPath.row].LName

        if (myTeamRank[indexPath.row].Status == 2) {
            cell.lblStatus.text = "Refunded"
        }else{
            cell.lblStatus.text = "Details"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
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




