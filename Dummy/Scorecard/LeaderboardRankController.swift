//
//  LeaderboardRankController.swift
//  Dummy
//
//  Created by Goldmedal on 30/10/21.
//

import UIKit

class LeaderboardRankController:  UIViewController {
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iScorecardListPresenter!
    var model: Match?
    private var leaderboardData: [LeaderboardData] = []
    
    var mid = Int()
    var lid = Int()
    weak var timer: Timer?
    var callFromScreen = String()
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        refreshControl.endRefreshing()
            self.presenter.getLeaderboardData(mid: self.mid, lid: self.lid, callFrom: Constant.LEADER_BOARD)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mid = model?.mID ?? -1
      
        presenter = ScorecardListPresenter(view: self)
        presenter.initInteractor()
        presenter.getLeaderboardData(mid: mid, lid: lid, callFrom: Constant.LEADER_BOARD)
        
        if(callFromScreen.elementsEqual("LIVE")){
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: Constant.LIVE_REFRESH_RATE,
                                 target: self,
                                 selector: #selector(self.update),
                                 userInfo: nil,
                                 repeats: true)
            }
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("** ** ** deinit LeaderboardRankController ** ** ** ")
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
    }
    
    
    
    
    @objc func update() {
        // do what should happen when timer triggers an event
        print("** ** ** LeaderboardRankController ** ** ** ")
        presenter.getLeaderboardData(mid: mid, lid: lid, callFrom: Constant.LEADER_BOARD)
    }
    
}



extension LeaderboardRankController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.LEADER_BOARD){
            leaderboardData = presenter.leaderboardData
            if(leaderboardData.count>0){
                /*Show Current User Rank At the top */
                let user = Utility.getUserName()
                let itemPosition = leaderboardData.firstIndex{$0.dN?.elementsEqual(user) == true}
                if(itemPosition != -1){
                    let myRankObj = leaderboardData.remove(at: itemPosition ?? 0)
                    leaderboardData.insert(myRankObj, at: 0)
                }
                print("** ** leaderboard data ** ** - - - ",leaderboardData)
                self.tableView.reloadData()
                noDataView.hideView(view: noDataView)
            }else{
                noDataView.showView(view: noDataView, from: "", msg: "")
            }
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getLeaderboardData(mid: mid, lid: lid, callFrom: Constant.LEADER_BOARD)
       }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension LeaderboardRankController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leaderboardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardRankCell", for: indexPath) as! LeaderboardRankCell
        cell.lblRank.text = String(leaderboardData[indexPath.row].rank ?? 0)
        cell.lblPoints.text = String(Int(leaderboardData[indexPath.row].score ?? 0.0))
        cell.lblWinning.text = String(Int(leaderboardData[indexPath.row].wamt ?? 0.0))
        cell.lblPlayerName.text = leaderboardData[indexPath.row].dN ?? ""
        
        cell.imvFlag.sd_setImage(with: URL(string: Constant.WEBSITE_URL + ("/\(leaderboardData[indexPath.row].flg ?? "")").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        
        if(indexPath.row == 0){
            cell.backgroundColor = UIColor.lightGray
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.init(named: "rankOutlineColor")?.cgColor
        }else{
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor.init(named: "cardBackground") ?? .lightGray
            }
            else {
                cell.backgroundColor = UIColor.white
            }
            cell.layer.borderWidth = 0.0
            
        }
        cell.layer.cornerRadius = 4.0
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcPreview = storyBoard.instantiateViewController(withIdentifier: "PreviewPopupController") as! PreviewPopupController
        vcPreview.showPoints = true
        vcPreview.mid = mid
        vcPreview.tid = leaderboardData[indexPath.row].id ?? 0
        vcPreview.strOwnerRank = String(leaderboardData[indexPath.row].rank ?? 0)
        vcPreview.strOwnerName = leaderboardData[indexPath.row].dN ?? "-"
        vcPreview.strOwnerPoints = String(leaderboardData[indexPath.row].score?.roundedDecimal ?? "")
        vcPreview.showHeader = true
       
        self.present(vcPreview, animated: false)
        
    }
    
}

