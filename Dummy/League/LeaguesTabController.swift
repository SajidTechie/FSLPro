//
//  LeaguesTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit
import XLPagerTabStrip

class LeaguesTabController: UIViewController,IndicatorInfoProvider,CommonDelegate {
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iLeaguePresenter!
    private var leagueForMatch: [LeagueDetailData] = []
    private var myTeam: [MyTeamNameData] = []
    private var joinLeague: [JoinedLeagueData] = []
    public var mid = Int()
    public var tid = Int()
    public var lid = Int()
    var pagerStrip = PagerTabStripViewController()
    var itemInfo: IndicatorInfo = "LEAGUES"
    var model: Match?
    
    var delegate: CommonDelegate?
    
    private var presenterMatches: iMatchesPresenter!
    private var rules: [GetRulesData] = []
    
    // MARK: - XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        pagerStrip = pagerTabStripController
        return itemInfo
    }
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        refreshControl.endRefreshing()
            self.presenter.getLeaguesForMatch(mid: self.mid,callFrom: Constant.LEAGUES_FOR_MATCH)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        presenterMatches = MatchesPresenter(view: self)
        presenterMatches.initInteractor()
        
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        
        presenter.getLeaguesForMatch(mid: mid,callFrom: Constant.LEAGUES_FOR_MATCH)
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
        
    }
   
    
    func refreshApi() {
        presenter.getLeaguesForMatch(mid: mid,callFrom: Constant.LEAGUES_FOR_MATCH)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
   
}



extension LeaguesTabController : LeaguePresentable,MatchesPresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.LEAGUES_FOR_MATCH){
            leagueForMatch = presenter.leagueForMatch
            if(leagueForMatch.count > 0){
                self.tableView.reloadData()
                noDataView.hideView(view: noDataView)
            }else{
                noDataView.showView(view: noDataView, from: "", msg: "")
            }
            print("** ** leagueForMatch data ** ** - - - ",leagueForMatch)
        }
        
      
        if(callFrom == Constant.MY_TEAM){
            myTeam = presenter.myTeam
            
            if(myTeam.count > 0){
                tid = myTeam[0].tID ?? -1
                if(tid != -1){
                    presenter.joinLeague(mid: mid, lid: lid, teamid: tid, callFrom: Constant.JOIN_LEAGUE)
                }
            }else{
                print("** ** myTeam switch tab here ** ** - - - ")
                NotificationCenter.default.post(name: NSNotification.Name("LEAGUE_TAB"), object: nil, userInfo: nil)
            }
            noDataView.hideView(view: noDataView)
        }
        
        
        if(callFrom == Constant.JOIN_LEAGUE){
            joinLeague = presenter.joinLeague
            let statusMsg = joinLeague[0].status ?? "-"
            print("** ** Join League data ** ** - - - ",statusMsg)
    
            presenterMatches.getRules(callFrom: Constant.RULES)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
            let vcJoinMsgPopup = storyBoard.instantiateViewController(withIdentifier: "JoinLeagueMsgPopup") as! JoinLeagueMsgPopup
            vcJoinMsgPopup.joinMsg = statusMsg
            vcJoinMsgPopup.delegate = self
            self.present(vcJoinMsgPopup, animated: false)
            noDataView.hideView(view: noDataView)
        }
        
        if(callFrom == Constant.RULES){
            rules = presenterMatches.rules
            if(rules.count > 0){
                let userName = rules[0].bal?.dN ?? "-"
                let walletBalance = String(rules[0].bal?.bAL ?? 0)
                let referralCode = rules[0].bal?.refCode ?? "-"
                
                UserDefaults.standard.set(userName, forKey: "UserName")
                UserDefaults.standard.set(walletBalance, forKey: "WalletBalance")
                UserDefaults.standard.set(referralCode, forKey: "ReferralCode")
                
                delegate?.refreshApi?()
                
            }
            noDataView.hideView(view: noDataView)
        }
        
     
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getLeaguesForMatch(mid: mid,callFrom: Constant.LEAGUES_FOR_MATCH)
        }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension LeaguesTabController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leagueForMatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = leagueForMatch[indexPath.row].ltype ?? 1
     
        switch type
        {
        case Constant.NORMAL_LEAGUE_TYPE:
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
         
            normalCell.lblLeagueName.text = leagueForMatch[indexPath.row].LName
            normalCell.lblWinningAmnt.text = Utility.currencyFormat(amount: leagueForMatch[indexPath.row].WinningAmt ?? 0.0)
            
            let entriesSize = leagueForMatch[indexPath.row].LMaxSize ?? 0
            let entriesJoined = leagueForMatch[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            if(leagueForMatch[indexPath.row].j == 0){
                normalCell.btnEntryFees.setTitle(Utility.currencyFormat(amount: leagueForMatch[indexPath.row].LEntryFees ?? 0.0), for: .normal)
              //change font size to 22dp
            }else{
                normalCell.btnEntryFees.setTitle("JOINED", for: .normal)
            }
            
            normalCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize)"

            if (entriesSize > 0) {
                normalCell.vwProgress.setProgress(Float(Float(entriesJoined)/Float(entriesSize)), animated: true)
            }
            
            normalCell.delegate = self
            return normalCell
            break
        
        case Constant.UNLIMITED_LEAGUE_TYPE:
            let unlimitedCell = tableView.dequeueReusableCell(withIdentifier: "UnlimitedLeagueCell", for: indexPath) as! UnlimitedLeagueCell
            
            unlimitedCell.lblLeagueName.text = leagueForMatch[indexPath.row].LName?.uppercased()
            unlimitedCell.lblWinningAmnt.text = Utility.currencyFormat(amount:leagueForMatch[indexPath.row].WinningAmt ?? 0.0)

            
            if ((leagueForMatch[indexPath.row].awards?.isEmpty) == false) {
                if ((leagueForMatch[indexPath.row].awards?[0].a?.isEmpty) == false) {
                    print("imvPrize.isHidden = false")
                    unlimitedCell.imvPrize.isHidden = false
                    unlimitedCell.imvPrize.sd_setImage(with: URL(string: Constant.WEBSITE_URL + ("/\(leagueForMatch[indexPath.row].awards?[0].a?[0].img ?? "")").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: ""))
               }else{
                   print("imvPrize.isHidden")
                   unlimitedCell.imvPrize.isHidden = true
                }
            }else{
                print("imvPrize.isHidden = true")
                unlimitedCell.imvPrize.isHidden = true
            }
            
            unlimitedCell.btnEntryFees.setTitle(Utility.currencyFormat(amount:leagueForMatch[indexPath.row].LEntryFees ?? 0.0), for: .normal)
            
            if(leagueForMatch[indexPath.row].j == 0){
                unlimitedCell.btnEntryFees.setTitle(Utility.currencyFormat(amount: leagueForMatch[indexPath.row].LEntryFees ?? 0.0), for: .normal)
              //change font size to 22dp
            }else{
                unlimitedCell.btnEntryFees.setTitle("JOINED", for: .normal)
            }

            
            let entriesSize = leagueForMatch[indexPath.row].LMaxSize ?? 0
            let entriesJoined = leagueForMatch[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            unlimitedCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize)"
            
            if (entriesSize > 0) {
                unlimitedCell.vwProgress.setProgress(Float(Float(entriesJoined)/Float(entriesSize)), animated: true)
            }
            
            unlimitedCell.delegate = self
            return unlimitedCell
            break
                               
        case Constant.SPONSOR_LEAGUE_TYPE:
            let sponsorCell = tableView.dequeueReusableCell(withIdentifier: "SpecialLeagueCell", for: indexPath) as! SpecialLeagueCell
          
            sponsorCell.lblLeagueName.text = leagueForMatch[indexPath.row].LName
            
            if(leagueForMatch[indexPath.row].j == 0){
                sponsorCell.btnEntryFees.setTitle(Utility.currencyFormat(amount: leagueForMatch[indexPath.row].LEntryFees ?? 0.0), for: .normal)
              //change font size to 22dp
            }else{
                sponsorCell.btnEntryFees.setTitle("JOINED", for: .normal)
            }
             
            let entriesSize = leagueForMatch[indexPath.row].LMaxSize ?? 0
            let entriesJoined = leagueForMatch[indexPath.row].LCurSize ?? 0
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
    
    
    
}

extension LeaguesTabController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension LeaguesTabController : LeaguesDelegate {
    func showInfo(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        
        if(position != -1){
            if(leagueForMatch[position].ltype == Constant.NORMAL_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "LeagueInfoViewPopup") as! LeagueInfoViewPopup
                vcLeagueInfo.leagueForMatch = leagueForMatch[position]
                self.present(vcLeagueInfo, animated: false)
            }
         
            if(leagueForMatch[position].ltype == Constant.UNLIMITED_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "JumboLeagueInfoPopup") as! JumboLeagueInfoPopup
                vcLeagueInfo.leagueForMatch = leagueForMatch[position]
                self.present(vcLeagueInfo, animated: false)
            }
            
            if(leagueForMatch[position].ltype == Constant.SPONSOR_LEAGUE_TYPE){
                let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
                let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "JumboLeagueInfoPopup") as! JumboLeagueInfoPopup
                vcLeagueInfo.leagueForMatch = leagueForMatch[position]
                self.present(vcLeagueInfo, animated: false)
            }
        }
        
    }
    
    func joinLeague(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let position = indexPath?.row ?? -1
        if(position != -1){
            lid  = leagueForMatch[position].LgId ?? -1
            presenter.getMyTeam(mid: mid, callFrom: Constant.MY_TEAM)//154
        }
        
        print("HIT\(String(describing: indexPath))")
    }
    
    
}



