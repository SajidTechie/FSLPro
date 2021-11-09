//
//  LeagueDetailCell.swift
//  Dummy
//
//  Created by Goldmedal on 29/10/21.
//

import UIKit

class LeagueDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblPeople : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
