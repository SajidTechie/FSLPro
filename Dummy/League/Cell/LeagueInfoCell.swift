//
//  LeagueInfoCell.swift
//  Dummy
//
//  Created by Goldmedal on 16/10/21.
//

import Foundation
import UIKit
class LeagueInfoCell: UITableViewCell {
    
    @IBOutlet weak var lblRank : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblCoins : UILabel!
    @IBOutlet weak var vwMain : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
