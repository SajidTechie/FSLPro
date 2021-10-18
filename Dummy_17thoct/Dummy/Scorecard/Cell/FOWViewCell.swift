//
//  FOWViewCell.swift
//  Dummy
//
//  Created by Goldmedal on 20/09/21.
//

import UIKit

class FOWViewCell: UITableViewCell {

    @IBOutlet weak var lblFallOfWickets : UILabel!
    @IBOutlet weak var lblFallOfWicketsRuns : UILabel!
    @IBOutlet weak var lblFallOfWicketsOvers : UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
