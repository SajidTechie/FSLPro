//
//  LeagueCell.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

protocol LeaguesDelegate: AnyObject {
    func joinLeague(cell: LeagueCell)
    func showInfo(cell: LeagueCell)
}

class LeagueCell: UITableViewCell {
    @IBOutlet weak var lblEntryFees : UILabel!
    @IBOutlet weak var lblWinningAmnt : UILabel!
    @IBOutlet weak var lblEntriesLeft : UILabel!
    @IBOutlet weak var lblLeagueName : UILabel!
    @IBOutlet weak var vwProgress : UIProgressView!
    @IBOutlet weak var vwJoin : UIView!
    @IBOutlet weak var vwShowInfo : UIView!
    weak var delegate: LeaguesDelegate?
 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let viewJoinLge = UITapGestureRecognizer(target: self, action: #selector(self.touchJoinLeague))
        vwJoin.isUserInteractionEnabled = true
        vwJoin.addGestureRecognizer(viewJoinLge)
        
        
        let viewShowInfo = UITapGestureRecognizer(target: self, action: #selector(self.touchShowInfo))
        vwShowInfo.isUserInteractionEnabled = true
        vwShowInfo.addGestureRecognizer(viewShowInfo)
    }
    
    @objc func touchJoinLeague(sender: UITapGestureRecognizer) {
        delegate?.joinLeague(cell: self)
    }
    
    
    @objc func touchShowInfo(sender: UITapGestureRecognizer) {
        delegate?.showInfo(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
