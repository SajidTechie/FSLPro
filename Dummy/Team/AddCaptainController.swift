//
//  AddCaptainController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

struct playerDetailObj:Codable{
    var PID:Int
    var Role: String
    var extRole: String
    
    init(PID:Int,Role:String,extRole:String)
    {
        self.PID = PID
        self.Role = Role
        self.extRole = extRole
    }
}


class AddCaptainController: UIViewController,CaptainSelectionDelegate,Presentable {

 
    private var presenter: iTeamsPresenter!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tblPlayer : UITableView!
    var selectedPlayerList: [MatchAllPlayerData] = []
    var savedPlayerList: [MatchAllPlayerData] = []
    var captainPosition = -1
    public var mid = Int()
    public var tid = Int()
    var teamDetail: [playerDetailObj] = []
    private var createEditTeam: [CreateEditTeamData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = TeamsPresenter(view: self)
        presenter.initInteractor()
        
        savedPlayerList.removeAll()
        savedPlayerList.append(contentsOf: selectedPlayerList)
      
        // Do any additional setup after loading the view.
        self.tblPlayer.dataSource = self
        self.tblPlayer.delegate = self
        
    }

    @IBAction func clickPreview(_ sender: UIButton) {
       print("preview clicked")

    }
    
    
    @IBAction func clickNext(_ sender: UIButton) {
        print("save clicked")
        if(captainPosition == -1){
            Utility.showMessage(title: "Invalid", msg: "Select Captain First")
        }else{
            teamDetail.removeAll()
            for i in 0...((self.savedPlayerList.count) - 1){
                teamDetail.append(playerDetailObj(PID: savedPlayerList[i].pID ?? 0, Role: savedPlayerList[i].rName ?? "", extRole: savedPlayerList[i].extRole ?? ""))
            }
            
        presenter.createEditTeam(mid: mid, teamid: tid, teamDetails: teamDetail, callFrom: Constant.CREATE_EDIT_TEAM)
        }
    }
    
    @objc func clickPlayer(sender : UITapGestureRecognizer) {
        if(sender.view!.tag >= 0){
            print("player name : \(selectedPlayerList[sender.view!.tag])")
        }
    }
    
    func selectCaptain(cell: CaptainSelectionCell) {
        let indexPath = self.tblPlayer.indexPath(for: cell)
        captainPosition = indexPath?.row ?? -1
        if(captainPosition != -1){
            selectedPlayerList.indices.forEach({
                selectedPlayerList[$0].extRole = ""
                savedPlayerList[$0].extRole = ""
            })
            selectedPlayerList[captainPosition].extRole = "C"
            savedPlayerList[captainPosition].extRole = "CAP"
        }
        self.tblPlayer.reloadData()
    }
    
    
}


extension AddCaptainController : TeamsPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
        createEditTeam = presenter.createEditTeamData
        
        print("createEditTeam - - - ",createEditTeam)
        
        if(createEditTeam.count > 0){
           print("Team saved - - ",createEditTeam)
            NotificationCenter.default.post(name: NSNotification.Name("TEAM_CREATED"), object: nil, userInfo: nil)
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}



extension AddCaptainController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPlayerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellCaptain = tableView.dequeueReusableCell(withIdentifier: "CaptainSelectionCell", for: indexPath) as! CaptainSelectionCell
        
        cellCaptain.lblTeamName.text = selectedPlayerList[indexPath.row].tName ?? ""
        cellCaptain.lblPlayerName.text = selectedPlayerList[indexPath.row].pName ?? ""
        cellCaptain.lblPlayerSkill.text = selectedPlayerList[indexPath.row].rName ?? ""
        cellCaptain.imvJersey.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (selectedPlayerList[indexPath.row].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        
        if(selectedPlayerList[indexPath.row].extRole?.elementsEqual("C") ?? false){
            cellCaptain.switchCaptain.isOn = true
        }else{
            cellCaptain.switchCaptain.isOn = false
        }
        
   //     cellCaptain.selectedPlayer = selectedPlayerList[indexPath.row]
        cellCaptain.delegate = self
        
        return cellCaptain
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

