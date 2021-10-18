//
//  LeagueStatsCell.swift
//  Dummy
//
//  Created by Apple on 22/09/21.
//

import UIKit

class LeagueStatsCell: UITableViewCell {
    
    @IBOutlet weak var imvCountry : UIImageView!
    @IBOutlet weak var lblPlayerName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
