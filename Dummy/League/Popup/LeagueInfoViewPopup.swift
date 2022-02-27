//
//  LeagueInfoViewPopup.swift
//  Dummy
//
//  Created by Goldmedal on 16/10/21.
//

import UIKit

class LeagueInfoViewPopup: UIViewController {
    
    @IBOutlet weak var lblEntry : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblWinner : UILabel!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var viewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var tblLeagueInfo : UITableView!
    
    public var leagueForMatch: LeagueDetailData? = nil
    public var leagueInfoArray: [LeagueRnk]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(leagueForMatch != nil){
            leagueInfoArray = leagueForMatch?.wData?.rnk
            
            lblPrice.text = String(leagueForMatch?.wData?.prz ?? 0)
            lblEntry.text = String(leagueForMatch?.wData?.ent ?? 0)
            lblWinner.text = String(leagueForMatch?.wData?.w ?? 0)
        }
        
        viewHeightLayout.constant = CGFloat(((leagueInfoArray?.count ?? 0) * 25) + 170)
        
        self.tblLeagueInfo.dataSource = self
        self.tblLeagueInfo.delegate = self
        
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension LeagueInfoViewPopup : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leagueInfoArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueInfoCell", for: indexPath) as! LeagueInfoCell

        cell.lblRank.text = leagueInfoArray?[indexPath.row].o ?? "-"
        cell.lblPrice.text = String(leagueInfoArray?[indexPath.row].coin ?? 0)
        
        if (indexPath.row % 2 == 0) {
            cell.vwMain.backgroundColor = UIColor.lightGray
        }
        else {
            cell.vwMain.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

