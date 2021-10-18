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
    public var mid = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        //TODO
        presenter.getLeaguesForMatch(mid: mid)//154
        
    }
    
    
}



extension LeaguesTabController : LeaguePresentable {
    func willLoadData() {
        
    }
    
    func didLoadData() {
        leagueForMatch = presenter.leagueForMatch
        
        print("** ** leagueForMatch data ** ** - - - ",leagueForMatch)
        
        self.tableView.reloadData()
        
    }
    
    func didFail(error: CustomError) {
        
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
        
        print("HIT\(String(describing: indexPath))")
    }
    
    
}



