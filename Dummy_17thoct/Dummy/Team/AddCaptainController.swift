//
//  AddCaptainController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class AddCaptainController: UIViewController,CaptainSelectionDelegate {
 
    
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tblPlayer : UITableView!
    var selectedPlayerList: [MatchAllPlayerData] = []
    var captainPosition = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblPlayer.dataSource = self
        self.tblPlayer.delegate = self
        
    }

    @IBAction func clickPreview(_ sender: UIButton) {
       print("preview clicked")
    }
    
    
    @IBAction func clickNext(_ sender: UIButton) {
        print("save clicked")
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
            })
            selectedPlayerList[captainPosition].extRole = "C"
        }
        self.tblPlayer.reloadData()
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

