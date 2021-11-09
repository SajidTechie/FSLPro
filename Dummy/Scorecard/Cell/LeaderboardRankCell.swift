//
//  LeaderboardRankCell.swift
//  Dummy
//
//  Created by Goldmedal on 30/10/21.
//

import UIKit

class LeaderboardRankCell: UITableViewCell {
    
    @IBOutlet weak var lblRank : UILabel!
    @IBOutlet weak var lblPlayerName : UILabel!
    @IBOutlet weak var lblWinning : UILabel!
    @IBOutlet weak var lblPoints : UILabel!
    @IBOutlet weak var imvFlag : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
