//
//  JumboLeagueInfoPopup.swift
//  Dummy
//
//  Created by Goldmedal on 07/03/22.
//

import UIKit

    class JumboLeagueInfoPopup: UIViewController {
        @IBOutlet weak var vwMain : UIView!
        @IBOutlet weak var lblEntry : UILabel!
        @IBOutlet weak var lblPrice : UILabel!
        @IBOutlet weak var lblWinner : UILabel!
        @IBOutlet weak var lblHeader : UILabel!
       
        @IBOutlet weak var viewHeightLayout: NSLayoutConstraint!
        @IBOutlet weak var tblLeagueInfo : UITableView!
        
        public var leagueForMatch: LeagueDetailData? = nil
        public var leagueInfoArray: [LeagueRnk]? = []

        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            if(leagueForMatch != nil){
                leagueInfoArray = leagueForMatch?.wData?.rnk
                
                lblHeader.text = leagueForMatch?.LName?.uppercased() ?? "-"
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


    extension JumboLeagueInfoPopup : UITableViewDataSource,UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return leagueInfoArray?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueInfoCell", for: indexPath) as! LeagueInfoCell

            cell.lblRank.text = leagueInfoArray?[indexPath.row].o ?? "-"
            cell.lblPrice.text = leagueInfoArray?[indexPath.row].prz ?? "-"
            cell.lblCoins.text = String(leagueInfoArray?[indexPath.row].coin ?? 0)
            
   
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

