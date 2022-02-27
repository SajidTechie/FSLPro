//
//  MyLeaguesTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//
//AKSHAY SHETTY
import UIKit
import XLPagerTabStrip
class MyLeaguesTabController: UIViewController,IndicatorInfoProvider {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iLeaguePresenter!
    private var myJoinedLeagues: [MyJoinedLeagueData] = []
    private var myJoinedLeagueDetail: [LeagueDetailData] = []
    
    private var myJoinedLeagueDetailMain: [LeagueDetailData] = []
    public var mid = Int()
    public var lid = Int()
    var pagerStrip = PagerTabStripViewController()
    var itemInfo: IndicatorInfo = "MY LEAGUES"
    
    // MARK: - XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        pagerStrip = pagerTabStripController
        return itemInfo
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        presenter.getMyJoinedLeagues(mid: mid,callFrom: Constant.MY_JOINED_LEAGUES)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
    func updateLeagueApi(){
        if(myJoinedLeagues.count > 0){
            for i in 0...(myJoinedLeagues.count - 1) {
                presenter.getMyJoinedLeagueDetail(mid: mid, lid: myJoinedLeagues[i].id ?? 0,position:i, callFrom: Constant.JOINED_LEAGUES_DETAIL)
            }
        }
    }
    
}



extension MyLeaguesTabController : LeaguePresentable {
    func willLoadData(callFrom:String) {
    
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.MY_JOINED_LEAGUES){
         
            
            myJoinedLeagues = presenter.myJoinedLeagues
            updateLeagueApi()
           
        }
        if (callFrom == Constant.JOINED_LEAGUES_DETAIL) {
            myJoinedLeagueDetail = presenter.myJoinedLeagueDetail
            
            let position = presenter.leagueDetailPosition
            
            myJoinedLeagueDetailMain.append(contentsOf: myJoinedLeagueDetail)
            
                    if(myJoinedLeagueDetailMain.count > 0){
                        myJoinedLeagueDetailMain[0].position = position
                        myJoinedLeagueDetailMain.sorted(by: { $0.position < $1.position })
                        
                        self.tableView.reloadData()
            
                    }
        }
       
       
        
        print("** ** my leagues ** ** - - - ",myJoinedLeagues)
        print("** ** my leagues detail** ** - - - ",myJoinedLeagueDetailMain)
    

       
       
     
    }
    
    func didFail(error: CustomError,callFrom:String) {
   //401 - -  refresh token
        
    }
}


extension MyLeaguesTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myJoinedLeagueDetailMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
        
        cell.btnEntryFees.setTitle(String(myJoinedLeagueDetailMain[indexPath.row].LEntryFees ?? 0.0), for: .normal)
        cell.lblLeagueName.text = myJoinedLeagueDetailMain[indexPath.row].LName
        cell.lblWinningAmnt.text = String(myJoinedLeagueDetailMain[indexPath.row].WinningAmt ?? 0.0)
        
        let entriesSize = myJoinedLeagueDetailMain[indexPath.row].LMaxSize ?? 0
        let entriesJoined = myJoinedLeagueDetailMain[indexPath.row].LCurSize ?? 0
        let entriesLeft = entriesSize - entriesJoined
        
        cell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize) LEFT"
        
        if (entriesSize > 0) {
            cell.vwProgress.setProgress(Float(Float(entriesJoined)/Float(entriesSize)), animated: true)
        }
        
        if (myJoinedLeagueDetailMain[indexPath.row].IsElastic ?? false) {
            cell.vwJoin.backgroundColor = UIColor.red
        }else{
            cell.vwJoin.backgroundColor = UIColor.blue
        }
      //  cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
        let vcLeagueEntry = storyBoard.instantiateViewController(withIdentifier: "LeagueEntryDetailController") as! LeagueEntryDetailController
        vcLeagueEntry.mid = mid
        vcLeagueEntry.lid = myJoinedLeagueDetailMain[indexPath.row].LgId ?? -1
        self.present(vcLeagueEntry, animated: true)
    }
    
}

