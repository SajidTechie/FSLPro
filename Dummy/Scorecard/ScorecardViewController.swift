//
//  ScorecardViewController.swift
//  Dummy
//
//  Created by Goldmedal on 20/09/21.
//

import UIKit

class ScorecardViewController: UIViewController {
    @IBOutlet weak var noDataView : NoDataView!
    @IBOutlet weak var lblExtras : UILabel!
    @IBOutlet weak var lblYetToBat : UILabel!
    @IBOutlet weak var lblTotal : UILabel!
    @IBOutlet weak var scrollMain : UIScrollView!
    @IBOutlet weak var tblBatsman : UITableView!
    @IBOutlet weak var tblBowler : UITableView!
    @IBOutlet weak var tblFow : UITableView!
    
    @IBOutlet weak var tblBatsmanHeight : NSLayoutConstraint!
    @IBOutlet weak var tblBowlerHeight : NSLayoutConstraint!
    @IBOutlet weak var tblFowHeight : NSLayoutConstraint!
    
    @IBOutlet weak var vwHorizontalStrip: UIView!
    
    private var presenter: iScorecardListPresenter!
    var scorecard: [ScorecardMain] = []
    
    private var scorecardBat : [ScorecardBat]? = []
    private var scorecardBowl : [ScorecardBol]? = []
    private var fallOfWickets : [ScorecardBat]? = []
    private var yetToBatArr : [String] = []
    
    var tabs = [ViewPagerTab]()
    var pager:ViewPager?
    let options = ViewPagerOptions()
    
    var arrInningsTabs = [String]()
    var initPosition = 0
    
    var callFrom = ""
    
    var bye = 0
    var lb = 0
    var wide = 0
    var nb = 0
    var pen = 0
    var totalExtra = 0
    
    var totalRuns = 0
    var totalOvers = 0.0
    var totalWickets = 0
    var inningsCount = 0
    
    public var mid = Int()
    var apiCall = false
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()

    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            refreshControl.endRefreshing()
            if(self.callFrom.elementsEqual("LIVE")){
                print("Call from live and no api is called")
            }else{
                self.presenter.getScorecard(mid: self.mid,callFrom: Constant.SCORECARD)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // - - - - creating desfault tab here
        tabs = [
           ViewPagerTab(title: "", image: UIImage(named: "")),
           ViewPagerTab(title: "", image: UIImage(named: ""))
       ]
        
        options.tabType = ViewPagerTabType.basic
        options.tabViewTextFont = UIFont(name: "Ubuntu Regular", size:12) ?? UIFont.systemFont(ofSize: 12)
        options.tabViewTextDefaultColor = UIColor.gray
        options.tabViewTextHighlightColor = UIColor.black
        options.distribution = .segmented
        options.tabViewBackgroundDefaultColor = UIColor.clear
        options.tabViewBackgroundHighlightColor = UIColor.clear
        options.isTabHighlightAvailable = true
        options.isTabIndicatorAvailable = true
        options.tabViewPaddingLeft = 20
        options.tabIndicatorViewBackgroundColor = UIColor.init(named: "darkRed") ?? UIColor.red
        options.tabIndicatorViewHeight = 2
        options.tabViewPaddingRight = 20
        options.tabViewHeight = 40
        
        pager = ViewPager(viewController: self, containerView: self.vwHorizontalStrip)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
        
        self.tblBatsman.tag = 1
        self.tblBowler.tag = 2
        self.tblFow.tag = 3
        
        if #available(iOS 10.0, *){
            scrollMain.refreshControl = refreshControl
        }else{
            scrollMain.addSubview(refreshControl)
        }
        
        if(callFrom.elementsEqual("LIVE")){
            
            if(scorecard.count>0)
            {inningsCount = scorecard[0].score?.count ?? 0}
            
            if(inningsCount > 1){
                self.vwHorizontalStrip.isUserInteractionEnabled = true
            }else{
                self.vwHorizontalStrip.isUserInteractionEnabled = false
            }
            
            
            if(scorecard.count > 0 && inningsCount > 0){
                
                createTabs(inning: inningsCount)
                setData()
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(liveScoreUpdate(_:)), name: NSNotification.Name("LIVE_SCORE"), object: nil)
        }else{
            presenter = ScorecardListPresenter(view: self)
            presenter.initInteractor()
            presenter.getScorecard(mid: mid,callFrom: Constant.SCORECARD)
        }
        
        self.tblBatsman.dataSource = self
        self.tblBowler.dataSource = self
        self.tblFow.dataSource = self
        
        self.tblBatsman.delegate = self
        self.tblBowler.delegate = self
        self.tblFow.delegate = self
      
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
   
    
    @objc func liveScoreUpdate(_ notification:Notification){
        
        let scorecardObj = notification.userInfo as! Dictionary<String,AnyObject>
        
        scorecard = scorecardObj["scorecard"] as? [ScorecardMain] ?? []
        print("LIVE SCORECARD 99- - - - - ",scorecard)
        
        if(scorecard.count>0)
        {inningsCount = scorecard[0].score?.count ?? 0}
       
        if(scorecard.count > 0 && inningsCount > 0){
            createTabs(inning: inningsCount)
            setData()
        }
      
    }
    
    
    // - - -  -  create innings tabs dynamically if count -> 0 (static 0 inning) , 1 -> (yet to bat static for 2nd inning), 2 -> dyn - - - -
    func createTabs(inning:Int){
        arrInningsTabs = []
        
        if(inning > 1){
            self.vwHorizontalStrip.isUserInteractionEnabled = true
        }else{
            self.vwHorizontalStrip.isUserInteractionEnabled = false
        }
        
        if(inning > 1){
            
            for i in 0...((scorecard[0].score?.count ?? 1)-1) {
                arrInningsTabs.append("\(scorecard[0].score?[i].bat?[0].t ?? "")\n\(String(scorecard[0].score?[i].total ?? 0))/\(String(scorecard[0].score?[i].wickets ?? 0))(\(String(scorecard[0].score?[i].overs ?? 0)))")
            }
        }
        else if(inning == 1){
            arrInningsTabs.append("\(scorecard[0].score?[0].bat?[0].t ?? "")\n\(String(scorecard[0].score?[0].total ?? 0))/\(String(scorecard[0].score?[0].wickets ?? 0))(\(String(scorecard[0].score?[0].overs ?? 0)))")
            arrInningsTabs.append("\(scorecard[0].score?[0].bol?[0].t ?? "")\nYet To bat")
        }
        else if(inning == 0){
            arrInningsTabs.append("\(scorecard[0].info?.lt?.name ?? "")\n(\(scorecard[0].info?.lt?.score ?? ""))")
            arrInningsTabs.append("\(scorecard[0].info?.vt?.name ?? "")\n(\(scorecard[0].info?.vt?.score ?? ""))")
        }
        
      tabs.removeAll()
        
        if(arrInningsTabs.count>0){
            for i in 0...(arrInningsTabs.count-1) {
                tabs.append(ViewPagerTab(title: arrInningsTabs[i], image: UIImage(named: "")))
            }
        }
        
        if(pager != nil)
        { pager?.invalidateCurrentTabs() }
        
    }
    
    
    func setData(){
       
        scorecardBat = scorecard[0].score?[initPosition].bat
        scorecardBowl = scorecard[0].score?[initPosition].bol
        
        let list = scorecard[0].score?[initPosition].bat?.filter { item in
            (item.fowBalls ?? 0.0 > 0.0)
        }.sorted(by: {$0.fowBalls ?? 0.0 < $1.fowBalls ?? 0.0})
        
        fallOfWickets = list
        
        tblBatsmanHeight.constant = CGFloat((scorecardBat?.count ?? 0) * 60)
        tblBowlerHeight.constant = CGFloat((scorecardBowl?.count ?? 0) * 40)
        tblFowHeight.constant = CGFloat((fallOfWickets?.count ?? 0) * 40)
        
        setExtraDetails(data: scorecard[0].score?[initPosition])
    
        if(scorecardBat?.count ?? 0 > 0){
            if(scorecard[0].info?.vt?.name?.contains(scorecardBat?[0].t ?? "") == true){
                yetToBatArr = scorecard[0].info?.vt?.playing ?? []
            }else if(scorecard[0].info?.lt?.name?.contains(scorecardBat?[0].t ?? "") == true){
                yetToBatArr = scorecard[0].info?.lt?.playing ?? []
            }
        }
        
        let batArr = scorecardBat?.map({$0.fn})
        let temp = yetToBatArr.filter{
            !(batArr?.contains($0) ?? false)
        }.joined(separator: ",")

        lblYetToBat.text = "(\(temp))"
    
        self.tblBatsman.reloadData()
        self.tblBowler.reloadData()
        self.tblFow.reloadData()
       
    }
    
    
    func setExtraDetails(data: ScorecardScore?) {
        
        bye = data?.xtra?.bye ?? 0
        lb = data?.xtra?.legBye ?? 0
        wide = data?.xtra?.wide ?? 0
        nb = data?.xtra?.noballRuns ?? 0
        pen = data?.xtra?.penalty ?? 0
        
        totalRuns = data?.total ?? 0
        totalWickets = data?.wickets ?? 0
        totalOvers = data?.overs ?? 0.0
        
        totalExtra = bye + lb + wide + nb + pen
        
        lblExtras.text = "\(totalExtra) (b \(bye),lb \(lb),w \(wide),nb \(nb),p \(pen))"
        lblTotal.text = "\(totalRuns) (\(totalWickets) wkts, \(totalOvers) overs)"
    }
    
}



extension ScorecardViewController : ScorecardListPresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        scorecard = presenter.scorecard
        
        print("scorecard - - - ",scorecard)
        
        if(scorecard.count > 0){
            inningsCount = scorecard[0].score?.count ?? 0
        }
    
        if(scorecard.count > 0 && inningsCount > 0){
            
            createTabs(inning: inningsCount)
            
            setData()
            noDataView.hideView(view: noDataView)
        }else{
            noDataView.showView(view: noDataView, from: "", msg: "")
        }
      
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getScorecard(mid: mid,callFrom: Constant.SCORECARD)
       }else{
           noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)
       }
    }
}


extension ScorecardViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return scorecardBat?.count ?? 0
        var count = 0
        if(tableView.tag == 1){
            count = scorecardBat?.count ?? 0
        }
        
        if(tableView.tag == 2){
            count = scorecardBowl?.count ?? 0
        }
        
        if(tableView.tag == 3){
            count = fallOfWickets?.count ?? 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView.tag == 1){
            let cellBat = tableView.dequeueReusableCell(withIdentifier: "BatsmanViewCell", for: indexPath) as! BatsmanViewCell
            
            cellBat.lblBattingText.text = scorecardBat?[indexPath.row].fn ?? "-"
            cellBat.lblBattingRuns.text = String(scorecardBat?[indexPath.row].score ?? 0)
            cellBat.lblBattingBalls.text = String(scorecardBat?[indexPath.row].ball ?? 0)
            cellBat.lblBatting4s.text = String(scorecardBat?[indexPath.row].four ?? 0)
            cellBat.lblBatting6s.text = String(scorecardBat?[indexPath.row].six ?? 0)
            cellBat.lblBattingSr.text = String(scorecardBat?[indexPath.row].rate ?? 0.0)
            
            switch scorecardBat?[indexPath.row].note {
            
            case "Not Out":
                cellBat.lblBattingDismissal.text = "not out"
            case  "Retired Hurt":
                cellBat.lblBattingDismissal.text = "retired hurt"
            case  "Hit Wicket":
                cellBat.lblBattingDismissal.text = "hit wicket"
            case  "Absent":
                cellBat.lblBattingDismissal.text = "absent"
            case  "Absent Hurt":
                cellBat.lblBattingDismissal.text = "absent Hurt"
            case "Obstructing the Field Out":
                cellBat.lblBattingDismissal.text = "obstructing the field out"
            case  "Run Out":
                if (scorecardBat?[indexPath.row].runout == nil || scorecardBat?[indexPath.row].runout?.isEmpty == true) {
                    cellBat.lblBattingDismissal.text =
                        "run out \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-"))"
                } else {
                    cellBat.lblBattingDismissal.text =
                        "run out \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-"))/\(String(describing: scorecardBat?[indexPath.row].runout ?? "-"))"
                }
            case  "Run Out (Sub)":
                if (scorecardBat?[indexPath.row].runout == nil || scorecardBat?[indexPath.row].runout?.isEmpty == true) {
                    cellBat.lblBattingDismissal.text =
                        "run out (sub) \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-"))"
                } else {
                    cellBat.lblBattingDismissal.text =
                        "run out (sub) \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-"))/\(String(describing: scorecardBat?[indexPath.row].runout ?? "-"))"
                }
            case "Catch Out":
                if ((scorecardBat?[indexPath.row].catchStumpPlayer) != nil) {
                    cellBat.lblBattingDismissal.text =
                        "c \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-")) b \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
                } else {
                    cellBat.lblBattingDismissal.text = "c & b \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
                }
            case   "Catch Out (Sub)":
                cellBat.lblBattingDismissal.text =
                    "c (sub) \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-")) b \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
            case "Stump Out":
                cellBat.lblBattingDismissal.text =
                    "st \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-")) b \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
            case  "Stump Out (Sub)":
                cellBat.lblBattingDismissal.text =
                    "st (sub) \(String(describing: scorecardBat?[indexPath.row].catchStumpPlayer ?? "-")) b \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
            case "LBW OUT":
                cellBat.lblBattingDismissal.text = "lbw \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
            case "Bowled":
                cellBat.lblBattingDismissal.text = "b \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
            case  "Clean Bowled":
                cellBat.lblBattingDismissal.text = "b \(String(describing: scorecardBat?[indexPath.row].bowlingPlayer ?? "-"))"
            default:
                cellBat.lblBattingDismissal.text = "not out"
            }
            return cellBat
        }
        
        if(tableView.tag == 2){
            let cellBowl = tableView.dequeueReusableCell(withIdentifier: "BowlerViewCell", for: indexPath) as! BowlerViewCell
            
            cellBowl.lblBowlingText.text = String(scorecardBowl?[indexPath.row].fn ?? "-")
            cellBowl.lblBowlingEco.text = String(scorecardBowl?[indexPath.row].rate ?? 0.0)
            cellBowl.lblBowlingMaidens.text = String(scorecardBowl?[indexPath.row].medians ?? 0)
            cellBowl.lblBowlingOvers.text = scorecardBowl?[indexPath.row].overs ?? "0.0"
            cellBowl.lblBowlingRuns.text = String(scorecardBowl?[indexPath.row].runs ?? 0)
            cellBowl.lblBowlingWickets.text = String(scorecardBowl?[indexPath.row].wickets ?? 0)
            
            return cellBowl
        }
        
        if(tableView.tag == 3){
            let cellFow = tableView.dequeueReusableCell(withIdentifier: "FOWViewCell", for: indexPath) as! FOWViewCell
            
            cellFow.lblFallOfWickets.text = fallOfWickets?[indexPath.row].fn ?? "-"
            cellFow.lblFallOfWicketsRuns.text = String(fallOfWickets?[indexPath.row].fowScore ?? 0)
            cellFow.lblFallOfWicketsOvers.text = String(fallOfWickets?[indexPath.row].fowBalls ?? 0.0)
            
            return cellFow
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = 40
        if(tableView.tag == 1){
            rowHeight = 60
        }
        
        if(tableView.tag == 2){
            rowHeight = 40
        }
        
        if(tableView.tag == 3){
            rowHeight = 40
        }
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ScorecardViewController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        let vc = UIViewController()
        
        if(position != -1)
        {
            initPosition = position
            
            if(scorecard.count > 0 && inningsCount > 0)
          {  setData()}
            
        }
        
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return initPosition
    }
    
}

extension ScorecardViewController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}


