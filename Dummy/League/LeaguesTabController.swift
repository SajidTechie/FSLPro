//
//  LeaguesTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit
import XLPagerTabStrip

class LeaguesTabController: UIViewController,IndicatorInfoProvider {
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
    
    // MARK: - XLPagerTabStrip
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        pagerStrip = pagerTabStripController
        return itemInfo
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        
        presenter.getLeaguesForMatch(mid: mid,callFrom: Constant.LEAGUES_FOR_MATCH)
        
    }
    
    
}



extension LeaguesTabController : LeaguePresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.LEAGUES_FOR_MATCH){
            leagueForMatch = presenter.leagueForMatch
            if(leagueForMatch.count > 0){
                self.tableView.reloadData()
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
        }
        
        if(callFrom == Constant.JOIN_LEAGUE){
            joinLeague = presenter.joinLeague
            let statusMsg = joinLeague[0].status ?? "-"
            print("** ** Join League data ** ** - - - ",statusMsg)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
            let vcJoinMsgPopup = storyBoard.instantiateViewController(withIdentifier: "JoinLeagueMsgPopup") as! JoinLeagueMsgPopup
            vcJoinMsgPopup.joinMsg = statusMsg
            self.present(vcJoinMsgPopup, animated: true)
        }
        
     
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


extension LeaguesTabController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leagueForMatch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       /* txtWinningAmt.text = currencyFormat(data?.WinningAmt?.toString() ?: "0")
                  txtLeagueName.text = data?.LName

                  when (data?.ltype) {
                      GlobalConstant.NORMAL_LEAGUE_TYPE -> {
                          bindLeagueCards(viewBinding)
                      }

                      GlobalConstant.SPONSOR_LEAGUE_TYPE -> {
                          beautifyForSponsorLeagues(viewBinding)
                      }
                      else -> {
                          bindLeagueCards(viewBinding)
                      }
                  }

                  if (data?.j == 0) {
                      btnEntryFees.text = currencyFormat(data.LEntryFees?.toString() ?: "0")
                      btnEntryFees.setTextSize(
                              TypedValue.COMPLEX_UNIT_PX,
                              context.resources.getDimension(R.dimen.dp_22))

                  } else {

                      btnEntryFees.text = context.resources.getString(R.string.str_joined)
                      btnEntryFees.setTextSize(
                              TypedValue.COMPLEX_UNIT_PX,
                              context.resources.getDimension(R.dimen.dp_18))
                  }


                  val entriesSize: Int = data?.LMaxSize ?: 0
                  val entriesJoined = data?.LCurSize ?: 0
                  val entriesLeft = entriesSize.minus(entriesJoined)

                  txtEntriesLeft.text = "$entriesLeft/$entriesSize"


      //            slider.valueFrom = 0f
                  if (entriesSize > 0) {
                      slider.max = entriesSize
                  }
                  slider.progress = entriesJoined
*/
        
        let type = leagueForMatch[indexPath.row].ltype ?? 1
     
        switch type
        {
        case Constant.NORMAL_LEAGUE_TYPE:
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
            normalCell.btnEntryFees.setTitle(Utility.currencyFormat(amount: leagueForMatch[indexPath.row].LEntryFees ?? 0.0), for: .normal)
            normalCell.lblLeagueName.text = leagueForMatch[indexPath.row].LName
            normalCell.lblWinningAmnt.text = Utility.currencyFormat(amount: leagueForMatch[indexPath.row].WinningAmt ?? 0.0)
            
            let entriesSize = leagueForMatch[indexPath.row].LMaxSize ?? 0
            let entriesJoined = leagueForMatch[indexPath.row].LCurSize ?? 0
            let entriesLeft = entriesSize - entriesJoined
            
            normalCell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize)"
            
            if (entriesSize > 0) {
                normalCell.vwProgress.setProgress(Float(entriesJoined/entriesSize), animated: true)
            }
            
            normalCell.delegate = self
            return normalCell
            break
        
        case Constant.UNLIMITED_LEAGUE_TYPE:
            let unlimitedCell = tableView.dequeueReusableCell(withIdentifier: "UnlimitedLeagueCell", for: indexPath) as! UnlimitedLeagueCell
            unlimitedCell.btnEntryFees.setTitle(Utility.currencyFormat(amount:leagueForMatch[indexPath.row].LEntryFees ?? 0.0), for: .normal)
            unlimitedCell.lblLeagueName.text = leagueForMatch[indexPath.row].LName
            unlimitedCell.lblWinningAmnt.text = Utility.currencyFormat(amount:leagueForMatch[indexPath.row].WinningAmt ?? 0.0)
            
            let entriesSize = leagueForMatch[indexPath.row].LMaxSize ?? 0
            let entriesJoined = leagueForMatch[indexPath.row].LCurSize ?? 0
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
            sponsorCell.btnEntryFees.setTitle(Utility.currencyFormat(amount:leagueForMatch[indexPath.row].LEntryFees ?? 0.0), for: .normal)
            sponsorCell.lblLeagueName.text = leagueForMatch[indexPath.row].LName
             
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
            let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
            let vcLeagueInfo = storyBoard.instantiateViewController(withIdentifier: "LeagueInfoViewPopup") as! LeagueInfoViewPopup
            vcLeagueInfo.leagueForMatch = leagueForMatch[position]
            self.present(vcLeagueInfo, animated: true)
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



