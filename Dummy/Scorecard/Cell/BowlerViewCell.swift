//
//  BowlerViewCell.swift
//  Dummy
//
//  Created by Goldmedal on 20/09/21.
//

import UIKit

class BowlerViewCell: UITableViewCell {
    @IBOutlet weak var lblBowlingText : UILabel!
    @IBOutlet weak var lblBowlingEco : UILabel!
    @IBOutlet weak var lblBowlingMaidens : UILabel!
    @IBOutlet weak var lblBowlingOvers : UILabel!
    @IBOutlet weak var lblBowlingRuns : UILabel!
    @IBOutlet weak var lblBowlingWickets : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
