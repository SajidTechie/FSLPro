//
//  LeagueCell.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

protocol LeaguesDelegate: AnyObject {
    func joinLeague(cell: UITableViewCell)
    func showInfo(cell: UITableViewCell)
}

class LeagueCell: UITableViewCell {
    @IBOutlet weak var btnEntryFees : UIButton!
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
        
        
//        let viewJoinLge = UITapGestureRecognizer(target: self, action: #selector(self.touchJoinLeague))
//        vwJoin.isUserInteractionEnabled = true
//        vwJoin.addGestureRecognizer(viewJoinLge)
        
        
        let viewShowInfo = UITapGestureRecognizer(target: self, action: #selector(self.touchShowInfo))
        vwJoin.isUserInteractionEnabled = true
        vwJoin.addGestureRecognizer(viewShowInfo)
    }
    
    @IBAction func touchJoinLeague(_ sender: UIButton) {
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
