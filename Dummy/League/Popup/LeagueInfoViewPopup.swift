//
//  LeagueInfoViewPopup.swift
//  Dummy
//
//  Created by Goldmedal on 16/10/21.
//

import UIKit

class LeagueInfoViewPopup: UIViewController {
    @IBOutlet weak var vwMain : UIView!
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var lblEntry : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblWinner : UILabel!
   
    @IBOutlet weak var viewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var tblLeagueInfo : UITableView!
    
    public var leagueForMatch: LeagueDetailData? = nil
    public var leagueInfoArray: [LeagueRnk]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(leagueForMatch != nil){
            leagueInfoArray = leagueForMatch?.wData?.rnk
            
            lblHeader.text = leagueForMatch?.LName?.uppercased() ?? ""
            lblPrice.text = String(leagueForMatch?.wData?.prz ?? 0)
            lblEntry.text = String(leagueForMatch?.wData?.ent ?? 0)
            lblWinner.text = String(leagueForMatch?.wData?.w ?? 0)
        }
        
        viewHeightLayout.constant = CGFloat(((leagueInfoArray?.count ?? 0) * 25) + 200)
        
        self.tblLeagueInfo.dataSource = self
        self.tblLeagueInfo.delegate = self
        
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
       {
           let touch = touches.first
           if touch?.view != self.vwMain
           { self.dismiss(animated: false, completion: nil) }
       }
    
    
}


extension LeagueInfoViewPopup : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leagueInfoArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueInfoCell", for: indexPath) as! LeagueInfoCell

        cell.lblRank.text = leagueInfoArray?[indexPath.row].o ?? "-"
        cell.lblCoins.text = String(leagueInfoArray?[indexPath.row].coin ?? 0)
        
//        if (position % 2 == 0) {
//            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
//                root.setBackgroundColor(context.resources.getColor(R.color.material_grey_200, null))
//            }
//        }
//        else {
//            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
//                root.setBackgroundColor(context.resources.getColor(R.color.white, null))
//            }
//
//           }
//
//        txtRank.text = data?.o ?: "-"
//        txtCoins.text = java.lang.String.valueOf(data?.coin ?: 0)
//        txtPrice.text = data?.prz ?: ""
        
        if (indexPath.row % 2 == 0) {
            cell.vwMain.backgroundColor = UIColor.init(named: "cardBackground") ?? .lightGray
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

