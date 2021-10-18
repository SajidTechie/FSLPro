//
//  TeamSelectionCellTableViewCell.swift
//  Dummy
//
//  Created by Apple on 20/09/21.
//

import UIKit

protocol TeamSelectionDelegate: AnyObject {
    func selectPlayer(cell: TeamSelectionCell,modelItem:MatchAllPlayerData)
}

class TeamSelectionCell: UITableViewCell {
    @IBOutlet weak var vwPlayer : UIView!
    @IBOutlet weak var imvJersey : UIImageView!
    @IBOutlet weak var lblPlayerName : UILabel!
    @IBOutlet weak var lblTeamName : UILabel!
    weak var delegate: TeamSelectionDelegate?
    var selectedPlayer: MatchAllPlayerData!
    
    var totalBatsman = 0
    var totalBowler = 0
    var totalAllRounder = 0
    var totalKeeper = 0
    
    var maxBatsman = 0
    var maxBowler = 0
    var maxAllRounder = 0
    var maxKeeper = 0
    
    var finalPlayerCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gestureSelectPlayer = UITapGestureRecognizer(target: self, action:  #selector(self.clickPlayer(sender:)))
        self.contentView.addGestureRecognizer(gestureSelectPlayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func clickPlayer(sender : UITapGestureRecognizer) {
        if(selectedPlayer != nil){
            
            if(selectedPlayer.selected ?? false ){
                selectedPlayer.selected = false
            }else{
                validatePlayer()
            }
        }
        delegate?.selectPlayer(cell: self, modelItem: selectedPlayer)
    }
    
    
    func validatePlayer(){
        if (selectedPlayer.rName == "WK" && totalKeeper >=  maxKeeper) {
            Utility.showMessage( title: "Invalid",msg: "Please Select \(maxKeeper) WK")
            return
        }
        
        if (selectedPlayer.rName == "BA" && totalBatsman >= maxBatsman) {
            Utility.showMessage( title: "Invalid",msg: "Please Select \(maxBatsman) BAT")
            return
        }
        
        if (selectedPlayer.rName == "AR" && totalAllRounder >= maxAllRounder) {
            Utility.showMessage( title: "Invalid",msg: "Please Select \(maxAllRounder) AR")
            return
        }
        
        if (selectedPlayer.rName == "BO" && totalBowler >= maxBowler) {
            Utility.showMessage( title: "Invalid",msg: "Please Select \(maxBowler) BO")
            return
        }
        
        
        if (finalPlayerCount == 11) {
            Utility.showMessage( title: "Invalid",msg: "Already 11 player selected")
            return
        }
        
        selectedPlayer.selected = true
    }
    
  
}
