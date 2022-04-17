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
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iLeaguePresenter!
    private var myJoinedLeagues: [MyJoinedLeagueData] = []
    private var myJoinedLeagueDetail: [LeagueDetailData] = []
    
    private var myJoinedLeagueDetailMain: [LeagueDetailData] = []
    public var mid = Int()
    public var lid = Int()
    var pagerStrip = PagerTabStripViewController()
    var itemInfo: IndicatorInfo = "MY LEAGUES"
    var model: Match?
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        refreshControl.endRefreshing()
            self.presenter.getMyJoinedLeagues(mid: self.mid,callFrom: Constant.MY_JOINED_LEAGUES)
        }
    }
    
    // MARK: - XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        pagerStrip = pagerTabStripController
        return itemInfo
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.presenter.getMyJoinedLeagues(mid: self.mid,callFrom: Constant.MY_JOINED_LEAGUES)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
        
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
       // presenter.getMyJoinedLeagues(mid: mid,callFrom: Constant.MY_JOINED_LEAGUES)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
       
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func updateLeagueApi(){
        myJoinedLeagueDetailMain.removeAll()
        if(myJoinedLeagues.count > 0){
            for i in 0...(myJoinedLeagues.count - 1) {
                presenter.getMyJoinedLeagueDetail(mid: mid, lid: myJoinedLeagues[i].id ?? 0,position:i, callFrom: Constant.JOINED_LEAGUES_DETAIL)
            }
        }else{
            noDataView.showView(view: self.noDataView, from: "", msg: StringConstants.league_not_joined)
        }
    }
    
}



extension MyLeaguesTabController : LeaguePresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.MY_JOINED_LEAGUES){
          
            myJoinedLeagues = presenter.myJoinedLeagues
            updateLeagueApi()
           // noDataView.hideView(view: noDataView)
        }
        
        if (callFrom == Constant.JOINED_LEAGUES_DETAIL) {
            myJoinedLeagueDetail = presenter.myJoinedLeagueDetail
            
            let position = presenter.leagueDetailPosition
            
            myJoinedLeagueDetailMain.append(contentsOf: myJoinedLeagueDetail)
            myJoinedLeagueDetailMain = myJoinedLeagueDetailMain.sorted(by: {$0.LEntryFees ?? 0.0 > $1.LEntryFees ?? 0.0})
            
            if(myJoinedLeagueDetailMain.count > 0){
                myJoinedLeagueDetailMain[0].position = position
              //  myJoinedLeagueDetailMain.sorted(by: { $0.position < $1.position })
             //   myJoinedLeagueDetailMain.sorted(by: {$0.LEntryFees ?? 0.0 < $1.LEntryFees ?? 0.0})
                self.tableView.reloadData()
                noDataView.hideView(view: noDataView)
            }else{
                noDataView.showView(view: noDataView, from: "", msg: "")
            }
           
        }
     
        print("** ** my leagues ** ** - - - ",myJoinedLeagues)
        print("** ** my leagues detail** ** - - - ",myJoinedLeagueDetailMain)
       
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getMyJoinedLeagues(mid: mid,callFrom: Constant.MY_JOINED_LEAGUES)
        }
        
       noDataView.hideView(view: noDataView)
    }
}


extension MyLeaguesTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myJoinedLeagueDetailMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let type = myJoinedLeagueDetailMain[indexPath.row].ltype ?? 1
        
        switch type
        {
        case Constant.NORMAL_LEAGUE_TYPE:
            
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
            
          //  normalCell.btnEntryFees.setTitle(String(myJoinedLeagueDetailMain[indexPath.row].LEntryFees ?? 0.0), for: .normal)
            normalCell.lblLeagueName.text = myJoinedLeagueDetailMain[indexPath.row].LName
            normalCell.lblWinningAmnt.text = Utility.currencyFormat(amount: myJoinedLeagueDetailMain[indexPath.row].WinningAmt ?? 0.0)//String(myJoinedLeagueDetailMain[indexPath.row].WinningAmt ?? 0.0)
            
            let entriesSize = myJoinedLeagueDetailMain[indexPath.row].LMaxSize ?? 0
            let entriesJoined = myJoinedLeagueDetailMain[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            normalCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize) LEFT"
            
            if (entriesSize > 0) {
                normalCell.vwProgress.setProgress(Float(Float(entriesJoined)/Float(entriesSize)), animated: true)
            }
            
            normalCell.delegate = self
            return normalCell
            break
            
        case Constant.UNLIMITED_LEAGUE_TYPE:
            
            let unlimitedCell = tableView.dequeueReusableCell(withIdentifier: "UnlimitedLeagueCell", for: indexPath) as! UnlimitedLeagueCell
        
            unlimitedCell.lblLeagueName.text = myJoinedLeagueDetailMain[indexPath.row].LName?.uppercased()
            unlimitedCell.lblWinningAmnt.text = Utility.currencyFormat(amount:myJoinedLeagueDetailMain[indexPath.row].WinningAmt ?? 0.0)
            
            if ((myJoinedLeagueDetailMain[indexPath.row].awards?.isEmpty) == false) {
                if ((myJoinedLeagueDetailMain[indexPath.row].awards?[0].a?.isEmpty) == false) {
                    print("imvPrize.isHidden = false")
                    unlimitedCell.imvPrize.isHidden = false
                    unlimitedCell.imvPrize.sd_setImage(with: URL(string: Constant.WEBSITE_URL + ("/\(myJoinedLeagueDetailMain[indexPath.row].awards?[0].a?[0].img ?? "")").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: ""))
               }else{
                   print("imvPrize.isHidden")
                   unlimitedCell.imvPrize.isHidden = true
                }
            }else{
                print("imvPrize.isHidden = true")
                unlimitedCell.imvPrize.isHidden = true
            }
            
            let entriesSize = myJoinedLeagueDetailMain[indexPath.row].LMaxSize ?? 0
            let entriesJoined = myJoinedLeagueDetailMain[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            unlimitedCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize)"
            
            if (entriesSize > 0) {
                unlimitedCell.vwProgress.setProgress(Float(entriesJoined/entriesSize), animated: true)
            }
            
            unlimitedCell.delegate = self
            return unlimitedCell
            break
            
        case Constant.SPONSOR_LEAGUE_TYPE:
            
            let sponsorCell = tableView.dequeueReusableCell(withIdentifier: "SpecialLeagueCell", for: indexPath) as! SpecialLeagueCell
            
        //    sponsorCell.btnEntryFees.setTitle(Utility.currencyFormat(amount:myJoinedLeagueDetailMain[indexPath.row].LEntryFees ?? 0.0), for: .normal)
            sponsorCell.lblLeagueName.text = myJoinedLeagueDetailMain[indexPath.row].LName
            
            let entriesSize = myJoinedLeagueDetailMain[indexPath.row].LMaxSize ?? 0
            let entriesJoined = myJoinedLeagueDetailMain[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            sponsorCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize)"
            
            sponsorCell.delegate = self
            return sponsorCell
            break
            
        default:
            return UITableViewCell()
            break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
}

extension MyLeaguesTabController : LeaguesDelegate {
    func showInfo(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        
//        if(position != -1){
//            let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
//            let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "LeagueInfoViewPopup") as! LeagueInfoViewPopup
//            vcLeagueInfo.leagueForMatch = myJoinedLeagueDetailMain[position]
//            self.present(vcLeagueInfo, animated: false)
//        }
        
        if(position != -1){
            if(myJoinedLeagueDetailMain[position].ltype == Constant.NORMAL_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "LeagueInfoViewPopup") as! LeagueInfoViewPopup
                vcLeagueInfo.leagueForMatch = myJoinedLeagueDetailMain[position]
                self.present(vcLeagueInfo, animated: false)
            }
         
            if(myJoinedLeagueDetailMain[position].ltype == Constant.UNLIMITED_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "JumboLeagueInfoPopup") as! JumboLeagueInfoPopup
                vcLeagueInfo.leagueForMatch = myJoinedLeagueDetailMain[position]
                self.present(vcLeagueInfo, animated: false)
            }
            
            if(myJoinedLeagueDetailMain[position].ltype == Constant.SPONSOR_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "JumboLeagueInfoPopup") as! JumboLeagueInfoPopup
                vcLeagueInfo.leagueForMatch = myJoinedLeagueDetailMain[position]
                self.present(vcLeagueInfo, animated: false)
            }
        }
        
    }
    
    func joinLeague(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        //        if(position != -1){
        //            lid  = leagueForMatch[position].LgId ?? -1
        //            presenter.getMyTeam(mid: mid, callFrom: Constant.MY_TEAM)//154
        //        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
        let vcLeagueEntry = storyBoard.instantiateViewController(withIdentifier: "LeagueEntryDetailController") as! LeagueEntryDetailController
        vcLeagueEntry.mid = mid
        vcLeagueEntry.model = model
        vcLeagueEntry.lid = myJoinedLeagueDetailMain[position].LgId ?? -1
        self.present(vcLeagueEntry, animated: true)
        
        print("HIT\(String(describing: indexPath))")
    }
    
    
}
