//
//  PreviewPopUp.swift
//  Dummy
//
//  Created by Goldmedal on 27/02/22.
//

import UIKit
import Foundation

@IBDesignable class PreviewPopUp: BaseCustomView{
    
    var strOwnerName = String()
    var strOwnerRank = String()
    var strOwnerPoints = String()
    
    public var mid = Int()
    public var tid = Int()
    
    private var captainIndex = -1
    var delegate: HandleHeaderBack?
    private var rank: Int = 0
    private var points: Int = 0
    @IBOutlet weak var headerViewHeight : NSLayoutConstraint!
    @IBOutlet weak var headerView : UIView!
    private var userName: String = ""
    
    var selectedPlayerList: [MatchAllPlayerData]? = []
    var teamPoints: [TeamPointsData]? = []
    
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblOwnerRank: UILabel!
    @IBOutlet weak var lblOwnerPoints: UILabel!
    @IBOutlet weak var imvOwner: UIImageView!
    
    @IBOutlet weak var btnCapPlayer0: UIButton!
    @IBOutlet weak var btnCapPlayer1: UIButton!
    @IBOutlet weak var btnCapPlayer2: UIButton!
    @IBOutlet weak var btnCapPlayer3: UIButton!
    @IBOutlet weak var btnCapPlayer4: UIButton!
    @IBOutlet weak var btnCapPlayer5: UIButton!
    @IBOutlet weak var btnCapPlayer6: UIButton!
    @IBOutlet weak var btnCapPlayer7: UIButton!
    @IBOutlet weak var btnCapPlayer8: UIButton!
    @IBOutlet weak var btnCapPlayer9: UIButton!
    @IBOutlet weak var btnCapPlayer10: UIButton!
    
    @IBOutlet weak var lblPlayer0Name: UILabel!
    @IBOutlet weak var lblPlayer1Name: UILabel!
    @IBOutlet weak var lblPlayer2Name: UILabel!
    @IBOutlet weak var lblPlayer3Name: UILabel!
    @IBOutlet weak var lblPlayer4Name: UILabel!
    @IBOutlet weak var lblPlayer5Name: UILabel!
    @IBOutlet weak var lblPlayer6Name: UILabel!
    @IBOutlet weak var lblPlayer7Name: UILabel!
    @IBOutlet weak var lblPlayer8Name: UILabel!
    @IBOutlet weak var lblPlayer9Name: UILabel!
    @IBOutlet weak var lblPlayer10Name: UILabel!
    
    @IBOutlet weak var lblPlayer0Point: UILabel!
    @IBOutlet weak var lblPlayer1Point: UILabel!
    @IBOutlet weak var lblPlayer2Point: UILabel!
    @IBOutlet weak var lblPlayer3Point: UILabel!
    @IBOutlet weak var lblPlayer4Point: UILabel!
    @IBOutlet weak var lblPlayer5Point: UILabel!
    @IBOutlet weak var lblPlayer6Point: UILabel!
    @IBOutlet weak var lblPlayer7Point: UILabel!
    @IBOutlet weak var lblPlayer8Point: UILabel!
    @IBOutlet weak var lblPlayer9Point: UILabel!
    @IBOutlet weak var lblPlayer10Point: UILabel!
    
    @IBOutlet weak var imvPlayer0: UIImageView!
    @IBOutlet weak var imvPlayer1: UIImageView!
    @IBOutlet weak var imvPlayer2: UIImageView!
    @IBOutlet weak var imvPlayer3: UIImageView!
    @IBOutlet weak var imvPlayer4: UIImageView!
    @IBOutlet weak var imvPlayer5: UIImageView!
    @IBOutlet weak var imvPlayer6: UIImageView!
    @IBOutlet weak var imvPlayer7: UIImageView!
    @IBOutlet weak var imvPlayer8: UIImageView!
    @IBOutlet weak var imvPlayer9: UIImageView!
    @IBOutlet weak var imvPlayer10: UIImageView!
    
    @IBOutlet weak var vwPreviewDetail: UIView!
    
    private var presenter: iTeamsPresenter!
 
    @IBAction func btnClose(_ sender: UIButton) {
        //  self.dismiss(animated: true, completion: nil)
        delegate?.onBackClick()
    }
    
    
    override func xibSetup() {
        super.xibSetup()
        
        setData()
    }
    
    
    func reloadPreview(showHeader:Bool){
        if(showHeader){
            headerView.isHidden = false
            headerViewHeight.constant = CGFloat(60.0)
        }else{
            headerView.isHidden = true
            headerViewHeight.constant = CGFloat(0.0)
        }
    }
    
    func callSelectedPlayerApi(){
        presenter.selectedTeam(mid: mid, teamid: tid, callFrom: Constant.SELECTED_TEAM_PLAYERS)
    }
    
    func callTeamPointsApi(mid:Int,tid:Int){
        self.mid = mid
        self.tid = tid
        presenter = TeamsPresenter(view: self)
        presenter.initInteractor()
        presenter.teamPoints(mid: mid, teamid: tid, callFrom: Constant.TEAM_POINTS)
    }
    
     func setData(){
         print("selectedPlayerList - - - - ",selectedPlayerList)
        guard let it = selectedPlayerList else {
            return
        }
        
        
        captainIndex = it.firstIndex{($0.extRole == "C" || $0.extRole == "CAP")} ?? -1
        
        let totalPlayers = it.count
        
        
        //initRecyclerView(it.toData())
        if (checkBounds(index: 0, totalPlayers: totalPlayers)) {
            lblPlayer0Name.text = getInitials(playerName: it[0].pName ?? "-")
            lblPlayer0Point.text = it[0].rName ?? "-"
            imvPlayer0.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[0].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        }
        
        if (checkBounds(index: 1, totalPlayers: totalPlayers)) {
            lblPlayer1Name.text = getInitials(playerName: it[1].pName ?? "-")
            lblPlayer1Point.text = it[1].rName ?? "-"
            imvPlayer1.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[1].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        }
        if (checkBounds(index: 2, totalPlayers: totalPlayers)) {
            lblPlayer2Name.text = getInitials(playerName: it[2].pName ?? "-")
            lblPlayer2Point.text = it[2].rName ?? "-"
            imvPlayer2.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[2].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        }
        if (checkBounds(index: 3, totalPlayers: totalPlayers)) {
            lblPlayer3Name.text = getInitials(playerName: it[3].pName ?? "-")
            lblPlayer3Point.text = it[3].rName ?? "-"
            imvPlayer3.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[3].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        }
        if (checkBounds(index: 4, totalPlayers: totalPlayers)) {
            lblPlayer4Name.text = getInitials(playerName: it[4].pName ?? "-")
            lblPlayer4Point.text = it[4].rName ?? "-"
            imvPlayer4.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[4].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        }
        if (checkBounds(index: 5, totalPlayers: totalPlayers)) {
            lblPlayer5Name.text = getInitials(playerName: it[5].pName ?? "-")
            lblPlayer5Point.text = it[5].rName ?? "-"
            imvPlayer5.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[5].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        }
        if (checkBounds(index: 6, totalPlayers: totalPlayers)) {
            lblPlayer6Name.text = getInitials(playerName: it[6].pName ?? "-")
            lblPlayer6Point.text = it[6].rName ?? "-"
            imvPlayer6.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[6].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        }
        if (checkBounds(index: 7, totalPlayers: totalPlayers)) {
            lblPlayer7Name.text = getInitials(playerName: it[7].pName ?? "-")
            lblPlayer7Point.text = it[7].rName ?? "-"
            imvPlayer7.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[7].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        }
        if (checkBounds(index: 8, totalPlayers: totalPlayers)) {
            lblPlayer8Name.text = getInitials(playerName: it[8].pName ?? "-")
            lblPlayer8Point.text = it[8].rName ?? "-"
            imvPlayer8.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[8].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        }
        if (checkBounds(index: 9, totalPlayers: totalPlayers)) {
            lblPlayer9Name.text = getInitials(playerName: it[9].pName ?? "-")
            lblPlayer9Point.text = it[9].rName ?? "-"
            imvPlayer9.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[9].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        }
        if (checkBounds(index: 10, totalPlayers: totalPlayers)) {
            lblPlayer10Name.text = getInitials(playerName: it[10].pName ?? "-")
            lblPlayer10Point.text = it[10].rName ?? "-"
            imvPlayer10.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[10].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        }
        
        /*Show Captain*/
        
        switch captainIndex {
        case 0 : btnCapPlayer0.isHidden = false
        case 1 : btnCapPlayer1.isHidden = false
        case 2 : btnCapPlayer2.isHidden = false
        case 3 : btnCapPlayer3.isHidden = false
        case 4 : btnCapPlayer4.isHidden = false
        case 5 : btnCapPlayer5.isHidden = false
        case 6 : btnCapPlayer6.isHidden = false
        case 7 : btnCapPlayer7.isHidden = false
        case 8 : btnCapPlayer8.isHidden = false
        case 9 : btnCapPlayer9.isHidden = false
        case 10 : btnCapPlayer10.isHidden = false
        default :
            print("No Captain Selected")
        }
    }
    
    func setHeaderValue(strOwnerName:String,strOwnerRank:String,strOwnerPoints:String){
        lblOwnerName.text = strOwnerName
        lblOwnerRank.text = "#\(strOwnerRank)"
        lblOwnerPoints.text = "\(strOwnerPoints) Points"
    
    }
    
    
    
    func setPointsData(){
        print("selectedPlayerList with points - - - - ",teamPoints)
       guard let it = teamPoints else {
           return
       }
       
       
       captainIndex = it.firstIndex{($0.extRole == "C" || $0.extRole == "CAP")} ?? -1
       
       let totalPlayers = it.count
       
       
       //initRecyclerView(it.toData())
       if (checkBounds(index: 0, totalPlayers: totalPlayers)) {
           lblPlayer0Name.text = getInitials(playerName: it[0].pName ?? "-")
           lblPlayer0Point.text = String(it[0].score?.roundedDecimal ?? "-")
           imvPlayer0.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[0].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
       }
       
       if (checkBounds(index: 1, totalPlayers: totalPlayers)) {
           lblPlayer1Name.text = getInitials(playerName: it[1].pName ?? "-")
           lblPlayer1Point.text = String(it[1].score?.roundedDecimal ?? "-")
           imvPlayer1.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[1].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
       }
       if (checkBounds(index: 2, totalPlayers: totalPlayers)) {
           lblPlayer2Name.text = getInitials(playerName: it[2].pName ?? "-")
           lblPlayer2Point.text = String(it[2].score?.roundedDecimal ?? "-")
           imvPlayer2.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[2].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
       }
       if (checkBounds(index: 3, totalPlayers: totalPlayers)) {
           lblPlayer3Name.text = getInitials(playerName: it[3].pName ?? "-")
           lblPlayer3Point.text = String(it[3].score?.roundedDecimal ?? "-")
           imvPlayer3.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[3].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
       }
       if (checkBounds(index: 4, totalPlayers: totalPlayers)) {
           lblPlayer4Name.text = getInitials(playerName: it[4].pName ?? "-")
           lblPlayer4Point.text = String(it[4].score?.roundedDecimal ?? "-")
           imvPlayer4.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[4].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
       }
       if (checkBounds(index: 5, totalPlayers: totalPlayers)) {
           lblPlayer5Name.text = getInitials(playerName: it[5].pName ?? "-")
           lblPlayer5Point.text = String(it[5].score?.roundedDecimal ?? "-")
           imvPlayer5.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[5].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
       }
       if (checkBounds(index: 6, totalPlayers: totalPlayers)) {
           lblPlayer6Name.text = getInitials(playerName: it[6].pName ?? "-")
           lblPlayer6Point.text = String(it[6].score?.roundedDecimal ?? "-")
           imvPlayer6.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[6].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
       }
       if (checkBounds(index: 7, totalPlayers: totalPlayers)) {
           lblPlayer7Name.text = getInitials(playerName: it[7].pName ?? "-")
           lblPlayer7Point.text = String(it[7].score?.roundedDecimal ?? "-")
           imvPlayer7.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[7].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
       }
       if (checkBounds(index: 8, totalPlayers: totalPlayers)) {
           lblPlayer8Name.text = getInitials(playerName: it[8].pName ?? "-")
           lblPlayer8Point.text = String(it[8].score?.roundedDecimal ?? "-")
           imvPlayer8.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[8].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
       }
       if (checkBounds(index: 9, totalPlayers: totalPlayers)) {
           lblPlayer9Name.text = getInitials(playerName: it[9].pName ?? "-")
           lblPlayer9Point.text = String(it[9].score?.roundedDecimal ?? "-")
           imvPlayer9.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[9].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
       }
       if (checkBounds(index: 10, totalPlayers: totalPlayers)) {
           lblPlayer10Name.text = getInitials(playerName: it[10].pName ?? "-")
           lblPlayer10Point.text = String(it[10].score?.roundedDecimal ?? "-")
           imvPlayer10.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (it[10].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
       }
       
       /*Show Captain*/
       
       switch captainIndex {
       case 0 : btnCapPlayer0.isHidden = false
       case 1 : btnCapPlayer1.isHidden = false
       case 2 : btnCapPlayer2.isHidden = false
       case 3 : btnCapPlayer3.isHidden = false
       case 4 : btnCapPlayer4.isHidden = false
       case 5 : btnCapPlayer5.isHidden = false
       case 6 : btnCapPlayer6.isHidden = false
       case 7 : btnCapPlayer7.isHidden = false
       case 8 : btnCapPlayer8.isHidden = false
       case 9 : btnCapPlayer9.isHidden = false
       case 10 : btnCapPlayer10.isHidden = false
       default :
           print("No Captain Selected")
       }
   }
    
    
    
    private func checkBounds(index: Int, totalPlayers: Int) -> Bool {
        return index < totalPlayers
    }
    
    private func getInitials(playerName: String) -> String {
      
        var initials = ""
        
        let nameFormatter = PersonNameComponentsFormatter()
        if let nameComps = nameFormatter.personNameComponents(from: playerName), let firstLetter = nameComps.givenName?.first, let lastName = nameComps.familyName {
            initials = "\(firstLetter). \(lastName)"
        }
  
        return initials
    }
    
}


extension PreviewPopUp : TeamsPresentable {
    func willLoadData(callFrom:String) {
        // noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom.elementsEqual(Constant.TEAM_POINTS)){
            teamPoints = presenter.teamPointsData
            print("points - - - ",teamPoints)
            
            
            setPointsData()
        }
        
      // noDataView.hideView(view: noDataView)
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.myTeamName(mid: mid, callFrom: Constant.MY_TEAM)
       }else{
         //  noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)
       }
    }
}



extension Float {
    var roundedDecimal: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}


