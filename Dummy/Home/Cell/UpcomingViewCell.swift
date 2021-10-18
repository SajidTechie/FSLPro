//
//  UpcomingViewCell.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit


class UpcomingViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTeamA : UILabel!
    @IBOutlet weak var lblTeamB : UILabel!
    @IBOutlet weak var lblLeague : UILabel!
    @IBOutlet weak var lblMatch : UILabel!
    @IBOutlet weak var lblTimer : UILabel!
    @IBOutlet weak var imvTeamALogo : UIImageView!
    @IBOutlet weak var imvTeamBLogo : UIImageView!
    var countdownTimer: Timer? = nil
    

    override func prepareForReuse() {
        super.prepareForReuse()

        countdownTimer?.invalidate()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
