//
//  LeaderboardRankController.swift
//  Dummy
//
//  Created by Goldmedal on 30/10/21.
//

import UIKit

class LeaderboardRankController:  UIViewController {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iScorecardListPresenter!
    
    private var leaderboardData: [LeaderboardData] = []
    
    var mid = Int()
    var lid = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        presenter = ScorecardListPresenter(view: self)
        presenter.initInteractor()
        presenter.getLeaderboardData(mid: mid, lid: lid, callFrom: Constant.LEADER_BOARD)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
}



extension LeaderboardRankController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.LEADER_BOARD){
            leaderboardData = presenter.leaderboardData
            print("** ** leaderboard data ** ** - - - ",leaderboardData)
            self.tableView.reloadData()
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


extension LeaderboardRankController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leaderboardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardRankCell", for: indexPath) as! LeaderboardRankCell
        cell.lblRank.text = String(leaderboardData[indexPath.row].rank ?? 0)
        cell.lblPoints.text = String(Int(leaderboardData[indexPath.row].score ?? 0.0))
        cell.lblWinning.text = String(Int(leaderboardData[indexPath.row].wamt ?? 0.0))
        cell.lblPlayerName.text = leaderboardData[indexPath.row].dN ?? ""
        
        cell.imvFlag.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (leaderboardData[indexPath.row].flg ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.lightGray
        }
        else {
            cell.backgroundColor = UIColor.white
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

