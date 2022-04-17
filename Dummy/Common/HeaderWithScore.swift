//
//  HeaderWithScore.swift
//  Dummy
//
//  Created by Goldmedal on 13/03/22.
//

import UIKit

class HeaderWithScore: BaseCustomView {
    @IBOutlet weak var imvBack : UIImageView!
    @IBOutlet weak var lblWalletBal : UILabel!
    @IBOutlet weak var lblAboutMatch : UILabel!
    
    @IBOutlet weak var lblResult : UILabel!
    @IBOutlet weak var lblTeam1Name : UILabel!
    @IBOutlet weak var lblTeam2Name : UILabel!
    @IBOutlet weak var lblTeam1Inn1Score : UILabel!
    @IBOutlet weak var lblTeam2Inn1Score : UILabel!
    @IBOutlet weak var vwResult : UIView!
    
    var delegate: HandleHeaderBack?

    var matchName = String()
  
    override func xibSetup() {
        super.xibSetup()
            
        let tabBackImage = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        imvBack.addGestureRecognizer(tabBackImage)
        
        let tapAboutMatch = UITapGestureRecognizer(target: self, action: #selector(self.tapAboutMatch))
        lblAboutMatch.addGestureRecognizer(tapAboutMatch)
    
    }
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        print("Edit Icon Clicked")
      
        delegate?.onBackClick()
    }
    
    
    @objc func tapAboutMatch(sender:UITapGestureRecognizer) {
        print("Edit Icon Clicked")
       
        delegate?.onAboutMatch()
    
    }
  
    func bindHeaderForLiveMatch(model: Match?, score: LiveScoreData,strResult:String){
    
        lblWalletBal.text = Utility.getWalletBalance()
        lblTeam1Name.text = model?.matchName?.components(separatedBy: " vs ").first
        lblTeam2Name.text = model?.matchName?.components(separatedBy: " vs ").last
        
        if(strResult.isEmpty){
            vwResult.isHidden = true
        }else{
            vwResult.isHidden = false
            lblResult.text = strResult
        }
        
     
        if(score.teamAScore?.contains(",") == true){
            let teamA = score.teamAScore?.split(separator: ",")
            if(teamA?.count ?? 0 > 0){
                lblTeam1Inn1Score.text = "\(teamA?[0] ?? "-")\n\(teamA?[1] ?? "-")"
            }else{
                lblTeam1Inn1Score.text = score.teamAScore ?? "-"
            }
        }else{
            lblTeam1Inn1Score.text = score.teamAScore ?? "-"
        }
        
        if(score.teamBScore?.contains(",") == true){
            let teamB = score.teamBScore?.split(separator: ",")
            if(teamB?.count ?? 0 > 0){
                lblTeam2Inn1Score.text = "\(teamB?[0] ?? "-")\n\(teamB?[1] ?? "-")"
            }else{
                lblTeam2Inn1Score.text = score.teamBScore ?? "-"
            }
        }else{
            lblTeam2Inn1Score.text = score.teamBScore ?? "-"
        }
    }

    func bindHeader(model: Match?, strResult:String){
    
        lblWalletBal.text = Utility.getWalletBalance()
        lblTeam1Name.text = model?.matchName?.components(separatedBy: " vs ").first
        lblTeam2Name.text = model?.matchName?.components(separatedBy: " vs ").last
        
        if(strResult.isEmpty){
            vwResult.isHidden = true
        }else{
            vwResult.isHidden = false
            lblResult.text = strResult
        }
        
     
        if(model?.teamAScore?.contains(",") == true){
            let teamA = model?.teamAScore?.split(separator: ",")
            if(teamA?.count ?? 0 > 0){
                lblTeam1Inn1Score.text = "\(teamA?[0] ?? "-")\n\(teamA?[1] ?? "-")"
            }else{
                lblTeam1Inn1Score.text = model?.teamAScore ?? "-"
            }
        }else{
            lblTeam1Inn1Score.text = model?.teamAScore ?? "-"
        }
        
        if(model?.teamBScore?.contains(",") == true){
            let teamB = model?.teamBScore?.split(separator: ",")
            if(teamB?.count ?? 0 > 0){
                lblTeam2Inn1Score.text = "\(teamB?[0] ?? "-")\n\(teamB?[1] ?? "-")"
            }else{
                lblTeam2Inn1Score.text = model?.teamBScore ?? "-"
            }
        }else{
            lblTeam2Inn1Score.text = model?.teamBScore ?? "-"
        }
    }
    
}
