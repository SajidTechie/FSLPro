//
//  CaptainSelectionCellTableViewCell.swift
//  Dummy
//
//  Created by Apple on 20/09/21.
//

import UIKit

protocol CaptainSelectionDelegate: AnyObject {
    func selectCaptain(cell: CaptainSelectionCell)
}


class CaptainSelectionCell: UITableViewCell {
    
    @IBOutlet weak var vwPlayer : UIView!
    @IBOutlet weak var imvJersey : UIImageView!
    @IBOutlet weak var lblPlayerName : UILabel!
    @IBOutlet weak var lblTeamName : UILabel!
    @IBOutlet weak var lblPlayerSkill : UILabel!
    @IBOutlet weak var btnSwitch : UIButton!
  
    weak var delegate: CaptainSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gestureSelectPlayer = UITapGestureRecognizer(target: self, action:  #selector(self.clickPlayer(sender:)))
        self.contentView.addGestureRecognizer(gestureSelectPlayer)
    }
    
    
    @objc func clickPlayer(sender : UITapGestureRecognizer) {
      
            
//            if(selectedPlayer.extRole?.elementsEqual("C") ?? false){
//                selectedPlayer.extRole = ""
//            }else{
//                selectedPlayer.extRole = "C"
//            }
          delegate?.selectCaptain(cell: self)
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
