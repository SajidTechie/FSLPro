//
//  SpecialLeagueCell.swift
//  Dummy
//
//  Created by Goldmedal on 22/02/22.
//

import UIKit

class SpecialLeagueCell: UITableViewCell {
    @IBOutlet weak var btnEntryFees : UIButton!
    @IBOutlet weak var lblSponsor : UILabel!
    @IBOutlet weak var lblEntriesLeft : UILabel!
    @IBOutlet weak var lblLeagueName : UILabel!
    @IBOutlet weak var vwJoin : UIView!
    @IBOutlet weak var vwShowInfo : UIView!
    @IBOutlet weak var vwProgress : UIProgressView!
    weak var delegate: LeaguesDelegate?
 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
