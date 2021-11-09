//
//  LeaguesTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class LeaguesTabController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iLeaguePresenter!
    private var leagueForMatch: [LeagueDetailData] = []
    private var myTeam: [MyTeamNameData] = []
    private var joinLeague: [JoinedLeagueData] = []
    public var mid = Int()
    public var tid = Int()
    public var lid = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        
        presenter.getLeaguesForMatch(mid: mid,callFrom: Constant.LEAGUES_FOR_MATCH)
        
    }
    
    
}



extension LeaguesTabController : LeaguePresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.LEAGUES_FOR_MATCH){
            leagueForMatch = presenter.leagueForMatch
            if(leagueForMatch.count > 0){
                self.tableView.reloadData()
            }
            print("** ** leagueForMatch data ** ** - - - ",leagueForMatch)
        }
        
      
        
        if(callFrom == Constant.MY_TEAM){
            myTeam = presenter.myTeam
            
            if(myTeam.count > 0){
                tid = myTeam[0].tID ?? -1
                if(tid != -1){
                    presenter.joinLeague(mid: mid, lid: lid, teamid: tid, callFrom: Constant.JOIN_LEAGUE)
                }
            }else{
                print("** ** myTeam switch tab here ** ** - - - ")
                NotificationCenter.default.post(name: NSNotification.Name("LEAGUE_TAB"), object: nil, userInfo: nil)
            }
        }
        
        if(callFrom == Constant.JOIN_LEAGUE){
            joinLeague = presenter.joinLeague
            let statusMsg = joinLeague[0].status ?? "-"
            print("** ** Join League data ** ** - - - ",statusMsg)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
            let vcJoinMsgPopup = storyBoard.instantiateViewController(withIdentifier: "JoinLeagueMsgPopup") as! JoinLeagueMsgPopup
            vcJoinMsgPopup.joinMsg = statusMsg
            self.present(vcJoinMsgPopup, animated: true)
        }
        
     
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


extension LeaguesTabController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leagueForMatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
        cell.lblEntryFees.text = String(leagueForMatch[indexPath.row].lEntryFees ?? 0.0)
        cell.lblLeagueName.text = leagueForMatch[indexPath.row].lName
        cell.lblWinningAmnt.text = String(leagueForMatch[indexPath.row].winningAmt ?? 0.0)
        
        let entriesSize = leagueForMatch[indexPath.row].lMaxSize ?? 0
        let entriesJoined = leagueForMatch[indexPath.row].lCurSize ?? 0
        let entriesLeft = entriesSize - entriesJoined
        
        cell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize) LEFT"
        
        if (entriesSize > 0) {
            cell.vwProgress.setProgress(Float(entriesJoined/entriesSize), animated: true)
        }
        
        if (leagueForMatch[indexPath.row].isElastic ?? false) {
            cell.vwJoin.backgroundColor = UIColor.red
        }else{
            cell.vwJoin.backgroundColor = UIColor.blue
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
}

extension LeaguesTabController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension LeaguesTabController : LeaguesDelegate {
    func showInfo(cell: LeagueCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        
        if(position != -1){
            let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
            let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "LeagueInfoViewPopup") as! LeagueInfoViewPopup
            vcLeagueInfo.leagueForMatch = leagueForMatch[position]
            self.present(vcLeagueInfo, animated: true)
        }
        
    }
    
    func joinLeague(cell: LeagueCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        if(position != -1){
            lid  = leagueForMatch[position].lgId ?? -1
            presenter.getMyTeam(mid: mid, callFrom: Constant.MY_TEAM)//154
        }
        
        print("HIT\(String(describing: indexPath))")
    }
    
    
}



