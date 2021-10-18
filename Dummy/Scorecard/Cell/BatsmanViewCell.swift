//
//  ScorecardViewCell.swift
//  Dummy
//
//  Created by Goldmedal on 20/09/21.
//

import UIKit

class BatsmanViewCell: UITableViewCell {

    @IBOutlet weak var lblBattingText : UILabel!
    @IBOutlet weak var lblBattingDismissal : UILabel!
    @IBOutlet weak var lblBattingRuns : UILabel!
    @IBOutlet weak var lblBattingBalls : UILabel!
    @IBOutlet weak var lblBatting4s : UILabel!
    @IBOutlet weak var lblBatting6s : UILabel!
    @IBOutlet weak var lblBattingSr : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
