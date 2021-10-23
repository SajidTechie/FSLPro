//
//  MyTeamTabController.swift
//  Dummy
//
//  Created by Goldmedal on 23/09/21.
//

import UIKit

class MyTeamTabController: UIViewController {
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblCaptainName: UILabel!
    
    @IBOutlet weak var vwCreateTeam: UIView!
    @IBOutlet weak var vwTeamDetail: UIView!
 
    private var presenter: iTeamsPresenter!
    private var myTeamName: [MyTeamNameData] = []
    
    public var mid = Int()
    public var tid = -1
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwTeamDetail.isHidden = true
        vwCreateTeam.isHidden = true
        
        presenter = TeamsPresenter(view: self)
        presenter.initInteractor()
        presenter.myTeamName(mid: mid, callFrom: Constant.MY_TEAM)
        
        let gestureCreateTeam = UITapGestureRecognizer(target: self, action:  #selector(self.clickCreateTeam(sender:)))
        self.vwCreateTeam.addGestureRecognizer(gestureCreateTeam)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTeamRefresh(_:)), name: NSNotification.Name("TEAM_CREATED"), object: nil)
        
    }
    
    
    @objc func CreateTeamRefresh(_ notification:Notification){
        print("Refresh team called")
        presenter.myTeamName(mid: mid, callFrom: Constant.MY_TEAM)
    }
    
    
    
    @objc func clickCreateTeam(sender : UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcCreateTeam = storyBoard.instantiateViewController(withIdentifier: "CreateTeamController") as! CreateTeamController
        vcCreateTeam.mid = mid
        vcCreateTeam.tid = tid
        self.navigationController!.pushViewController(vcCreateTeam, animated: true)
    }
    
    @IBAction func editTeam(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcCreateTeam = storyBoard.instantiateViewController(withIdentifier: "CreateTeamController") as! CreateTeamController
        self.navigationController!.pushViewController(vcCreateTeam, animated: true)
    }
    
    @IBAction func previewTeam(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcCreateTeam = storyBoard.instantiateViewController(withIdentifier: "CreateTeamController") as! CreateTeamController
        self.navigationController!.pushViewController(vcCreateTeam, animated: true)
    }
    
    
}



extension MyTeamTabController : TeamsPresentable {
    func willLoadData(callFrom:String) {
    
    }
    
    func didLoadData(callFrom:String){
        myTeamName = presenter.teamNameData
     
        print("** ** team name ** ** - - - ",myTeamName)
     
        if(myTeamName.count>0){
            vwTeamDetail.isHidden = false
            vwCreateTeam.isHidden = true
            
            lblTeamName.text = myTeamName[0].name ?? ""
            lblCaptainName.text = myTeamName[0].player ?? ""
            
            tid = myTeamName[0].tID ?? -1
        }else{
            vwTeamDetail.isHidden = true
            vwCreateTeam.isHidden = false
        }
     
    }
    
    func didFail(error: CustomError,callFrom:String) {
   
    }
}


