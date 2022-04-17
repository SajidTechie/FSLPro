//
//  MyTeamTabController.swift
//  Dummy
//
//  Created by Goldmedal on 23/09/21.
//

import UIKit
import XLPagerTabStrip
class MyTeamTabController: UIViewController,IndicatorInfoProvider {
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var previewPopupView : PreviewPopUp!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblCaptainName: UILabel!
    @IBOutlet weak var vwCreateTeam: UIView!
    @IBOutlet weak var vwTeamDetail: RoundView!
 
    private var presenter: iTeamsPresenter!
    private var myTeamName: [MyTeamNameData] = []
    var model: Match?
    private var selectedTeamList: [MatchAllPlayerData] = []
    
    public var mid = Int()
    public var tid = -1
    var pagerStrip = PagerTabStripViewController()
    var itemInfo: IndicatorInfo = "MY TEAM"
    
    // MARK: - XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        pagerStrip = pagerTabStripController
        return itemInfo
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwTeamDetail.isHidden = true
        vwCreateTeam.isHidden = true
        previewPopupView.vwPreviewDetail.isHidden = true
        
        presenter = TeamsPresenter(view: self)
        presenter.initInteractor()
        presenter.myTeamName(mid: mid, callFrom: Constant.MY_TEAM)
        
        let gestureCreateTeam = UITapGestureRecognizer(target: self, action:  #selector(self.clickCreateTeam(sender:)))
        self.vwCreateTeam.addGestureRecognizer(gestureCreateTeam)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTeamRefresh(_:)), name: NSNotification.Name("TEAM_CREATED"), object: nil)
        
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func CreateTeamRefresh(_ notification:Notification){
        print("Refresh team called")
        presenter.myTeamName(mid: mid, callFrom: Constant.MY_TEAM)
       
    }
    
    
    
    @objc func clickCreateTeam(sender : UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcCreateTeam = storyBoard.instantiateViewController(withIdentifier: "CreateTeamController") as! CreateTeamController
        vcCreateTeam.callFromScreen = "create"
        vcCreateTeam.model = model
        vcCreateTeam.mid = mid
        vcCreateTeam.tid = tid
       // self.present(vcCreateTeam, animated: true)
       self.navigationController!.pushViewController(vcCreateTeam, animated: true)
    }
    
    @IBAction func editTeam(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcCreateTeam = storyBoard.instantiateViewController(withIdentifier: "CreateTeamController") as! CreateTeamController
        vcCreateTeam.model = model
        vcCreateTeam.mid = mid
        vcCreateTeam.tid = tid
        vcCreateTeam.callFromScreen = "edit"
     //   self.present(vcCreateTeam, animated: true)
        self.navigationController!.pushViewController(vcCreateTeam, animated: true)
    }
    
//    @IBAction func previewTeam(_ sender: UIButton) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
//        let vcCreateTeam = storyBoard.instantiateViewController(withIdentifier: "CreateTeamController") as! CreateTeamController
//       // self.present(vcCreateTeam, animated: true)
//        self.navigationController!.pushViewController(vcCreateTeam, animated: true)
//    }
    
    
}



extension MyTeamTabController : TeamsPresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom.elementsEqual(Constant.MY_TEAM)){
            myTeamName = presenter.teamNameData
         
            print("** ** team name ** ** - - - ",myTeamName)
         
            if(myTeamName.count>0){
                vwTeamDetail.isHidden = false
                vwCreateTeam.isHidden = true
                
           //     lblTeamName.text = myTeamName[0].name ?? ""
                lblCaptainName.text = myTeamName[0].player ?? ""
                
                tid = myTeamName[0].tID ?? -1
                
                presenter.selectedTeam(mid: mid, teamid: tid, callFrom: Constant.SELECTED_TEAM_PLAYERS)
            }else{
                vwTeamDetail.isHidden = true
                vwCreateTeam.isHidden = false
                previewPopupView.vwPreviewDetail.isHidden = true
            }
        }
        
        if(callFrom.elementsEqual(Constant.SELECTED_TEAM_PLAYERS)){
            selectedTeamList = presenter.selectedTeamData
            //refresh preview popup
            
            var selectedPlayerList =  selectedTeamList.filter { it in
                (it.selected ?? false)
            }
           
            previewPopupView.vwPreviewDetail.isHidden = false
            previewPopupView.reloadPreview(showHeader: false)
            
            previewPopupView.selectedPlayerList = selectedPlayerList
            previewPopupView.setData()
        }
        
       noDataView.hideView(view: noDataView)
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.myTeamName(mid: mid, callFrom: Constant.MY_TEAM)
       }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


