//
//  LeagueEntryDetailController.swift
//  Dummy
//
//  Created by Goldmedal on 01/11/21.
//

import UIKit

class LeagueEntryDetailController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iLeaguePresenter!
    
    private var leagueEntryData: [LeagueEntryDetailsData] = []
    
    var mid = Int()
    var lid = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        presenter.getLeagueEntryDetail(mid: mid, lid: lid, callFrom: Constant.LEAGUE_ENTRY_DETAILS)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
}



extension LeagueEntryDetailController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.LEAGUE_ENTRY_DETAILS){
            leagueEntryData = presenter.leagueEntryDetail
            print("** ** leagueEntryDetail data ** ** - - - ",leagueEntryData)
            self.tableView.reloadData()
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


extension LeagueEntryDetailController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueEntryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueStatsCell", for: indexPath) as! LeagueStatsCell
    
        cell.lblPlayerName.text = leagueEntryData[indexPath.row].dN ?? ""
        
        cell.imvCountry.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (leagueEntryData[indexPath.row].flg ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        
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

