//
//  CompletedViewCell.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class CompletedViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTeamA : UILabel!
    @IBOutlet weak var lblTeamB : UILabel!
    @IBOutlet weak var lblLeague : UILabel!
    @IBOutlet weak var lblMatch : UILabel!
    @IBOutlet weak var lblResult : UILabel!
    @IBOutlet weak var imvTeamALogo : UIImageView!
    @IBOutlet weak var imvTeamBLogo : UIImageView!
    @IBOutlet weak var lblTeamAScore1 : UILabel!
    @IBOutlet weak var lblTeamBScore1 : UILabel!
    @IBOutlet weak var lblTeamAScore2 : UILabel!
    @IBOutlet weak var lblTeamBScore2 : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
