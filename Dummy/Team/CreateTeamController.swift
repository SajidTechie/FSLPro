//
//  CreateTeamController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class CreateTeamController: BaseViewController, Presentable, TeamSelectionDelegate {
    @IBOutlet weak var noDataView : NoDataView!
    
    @IBOutlet weak var imvHomeTeam : UIImageView!
    @IBOutlet weak var imvAwayTeam : UIImageView!
    @IBOutlet weak var lblHomeTeamCount : UILabel!
    @IBOutlet weak var lblAwayTeamCount : UILabel!
    @IBOutlet weak var lblPlayersCount : UILabel!
    
    @IBOutlet weak var btnSelector1 : UIButton!
    @IBOutlet weak var btnSelector2 : UIButton!
    @IBOutlet weak var btnSelector3 : UIButton!
    @IBOutlet weak var btnSelector4 : UIButton!
    @IBOutlet weak var btnSelector5 : UIButton!
    @IBOutlet weak var btnSelector6 : UIButton!
    @IBOutlet weak var btnSelector7 : UIButton!
    @IBOutlet weak var btnSelector8 : UIButton!
    @IBOutlet weak var btnSelector9 : UIButton!
    @IBOutlet weak var btnSelector10 : UIButton!
    @IBOutlet weak var btnSelector11 : UIButton!
    
    @IBOutlet weak var header : HeaderWithTimer!
    @IBOutlet weak var tblPlayer : UITableView!
    
    @IBOutlet weak var vwHorizontalStrip: RoundView!
     
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    private var presenter: iTeamsPresenter!
    private var presenterMatches: iMatchesPresenter!
    private var rules: [GetRulesData] = []
    
    private var allTeamList: [MatchAllPlayerData] = []
    private var batsmanList: [MatchAllPlayerData] = []
    private var bowlerList: [MatchAllPlayerData] = []
    private var wicketKeeperList: [MatchAllPlayerData] = []
    private var allRounderList: [MatchAllPlayerData] = []
    private var visiblePlayerList: [MatchAllPlayerData] = []
    var model: Match?
  
    var tabs = [ViewPagerTab]()
    var pager:ViewPager?
    let options = ViewPagerOptions()
    
    var initPosition = 0
    var arrPositionTabs = [String]()
    
    var totalBatsman = 0
    var totalBowler = 0
    var totalAllRounder = 0
    var totalKeeper = 0
    
    var maxBatsman = 0
    var maxBowler = 0
    var maxAllRounder = 0
    var maxKeeper = 0
    
    var minBatsman = 0
    var minBowler = 0
    var minAllRounder = 0
    var minKeeper = 0
    
    var finalPlayerCount = 0
    
    public var mid = Int()
    public var tid = Int()
    
    var team1 = 0
    var team2 = 0
   // var totalPlayers = 0
    var refreshCall = false
    var editFirstTime = false
    var callFromScreen = String()
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.noDataView.hideView(view: self.noDataView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            refreshControl.endRefreshing()
            self.refreshCall = true
            if(self.allTeamList.count == 0){
            self.presenterMatches.getRules(callFrom: Constant.RULES)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.delegate = self
        self.header.bindHeader(model: model)
        
        createTabs()
        
        // - - - set home and away flags
        imvHomeTeam.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (model?.teamALogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        imvAwayTeam.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (model?.teamBLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        
        if(!callFromScreen.elementsEqual("create")){
            editFirstTime = true
        }
        
       
        presenter = TeamsPresenter(view: self)
        presenter.initInteractor()
      
        
        presenterMatches = MatchesPresenter(view: self)
        presenterMatches.initInteractor()
        presenterMatches.getRules(callFrom: Constant.RULES)
            
        options.tabType = ViewPagerTabType.basic
        options.tabViewTextFont = UIFont.systemFont(ofSize: 13)
        options.tabViewTextDefaultColor = UIColor.black
        options.distribution = .segmented
        options.tabViewBackgroundDefaultColor = UIColor.clear
        options.isTabHighlightAvailable = true
        options.isTabIndicatorAvailable = true
        options.tabViewBackgroundHighlightColor = UIColor.lightGray
       // options.shadowRadius = 1.0
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.tabViewHeight = 40
     

       // pager = ViewPager(viewController: self)
        pager = ViewPager(viewController: self, containerView: self.vwHorizontalStrip)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
        
        if (callFromScreen.elementsEqual("create")) {
            if #available(iOS 10.0, *){
                tblPlayer.refreshControl = refreshControl
            }else{
                tblPlayer.addSubview(refreshControl)
            }
        }
        
        self.tblPlayer.dataSource = self
        self.tblPlayer.delegate = self
        
    }
   
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // - - - - - function to create tabs - - - - - -
    func createTabs(){
        arrPositionTabs = ["WK\n\(totalKeeper)/\(maxKeeper)", "BAT\n\(totalBatsman)/\(maxBatsman)", "AR\n\(totalAllRounder)/\(maxAllRounder)",  "BOW\n\(totalBowler)/\(maxBowler)"]

        tabs.removeAll()
        for i in 0...(arrPositionTabs.count-1) {
            tabs.append(ViewPagerTab(title: arrPositionTabs[i], image: UIImage(named: "")))
        }

        if(pager != nil)
        { pager?.invalidateCurrentTabs() }
   
    }
    
    
    func setData(refreshCall:Bool){
        
        batsmanList = allTeamList.filter { it in
            (it.rName?.elementsEqual("BA") ?? false)
        }
        bowlerList = allTeamList.filter { it in
            (it.rName?.elementsEqual("BO") ?? false)
        }
        allRounderList = allTeamList.filter { it in
            (it.rName?.elementsEqual("AR") ?? false)
        }
        wicketKeeperList = allTeamList.filter { it in
            (it.rName?.elementsEqual("WK") ?? false)
        }
       
        if(initPosition == 0){
            visiblePlayerList.removeAll()
            visiblePlayerList = wicketKeeperList
            
            totalKeeper = wicketKeeperList.filter { it in
                (it.selected ?? false)
            }.count
        }
        
        if(initPosition == 1){
            visiblePlayerList.removeAll()
            visiblePlayerList = batsmanList
            
            totalBatsman = batsmanList.filter { it in
                (it.selected ?? false)
            }.count
        }
        
        if(initPosition == 2){
            visiblePlayerList.removeAll()
            visiblePlayerList = allRounderList
            
            totalAllRounder = allRounderList.filter { it in
                (it.selected ?? false)
            }.count

        }
        
        if(initPosition == 3){
            visiblePlayerList.removeAll()
            visiblePlayerList = bowlerList
            
            totalBowler = bowlerList.filter { it in
                (it.selected ?? false)
            }.count
        }
        
        // - - - -  call from edit and setting tab values
        if(editFirstTime){
            totalKeeper = wicketKeeperList.filter { it in
                (it.selected ?? false)
            }.count
            
            totalAllRounder = allRounderList.filter { it in
                (it.selected ?? false)
            }.count
            
            totalBatsman = batsmanList.filter { it in
                (it.selected ?? false)
            }.count
            
            totalBowler = bowlerList.filter { it in
                (it.selected ?? false)
            }.count
        }
        
        if(refreshCall){
            totalKeeper = 0
            totalBatsman = 0
            totalAllRounder = 0
            totalBowler = 0
        }
        
        print("visiblePlayerList List - - - ",visiblePlayerList)
        
        print("TOTAL ***** ***** ",totalKeeper," - - - ",totalBatsman," - - - ",totalAllRounder," - - - ",totalBowler)
        
        finalPlayerCount = totalKeeper + totalBatsman + totalAllRounder + totalBowler
        
        if(finalPlayerCount > 0){
            btnPreview.isEnabled = true
            btnPreview.alpha = 1
            if(finalPlayerCount == 11){
                
                if (totalKeeper < minKeeper) {
                    btnNext.isEnabled = false
                    btnNext.alpha = 0.5
                }
                else if (totalBatsman < minBatsman) {
                    btnNext.isEnabled = false
                    btnNext.alpha = 0.5
                }
                else if (totalAllRounder < minAllRounder) {
                    btnNext.isEnabled = false
                    btnNext.alpha = 0.5
                }
                else if (totalBowler < minBowler) {
                    btnNext.isEnabled = false
                    btnNext.alpha = 0.5
                }else{
                    btnNext.isEnabled = true
                    btnNext.alpha = 1
                }
              
            }else{
                btnNext.isEnabled = false
                btnNext.alpha = 0.5
            }
        }else{
            btnPreview.isEnabled = false
            btnNext.isEnabled = false
            btnNext.alpha = 0.5
            btnPreview.alpha = 0.5
        }
     
        
        team1 = allTeamList.filter{($0.selected == true) && ($0.tName == model?.teamA)}.count
        team2 = allTeamList.filter{($0.selected == true) && ($0.tName == model?.teamB)}.count
        
        createTabs()
        
        lblHomeTeamCount.text = String(team1)
        lblAwayTeamCount.text = String(team2)
        
      //  lblPlayersCount.text = "PLAYERS \(finalPlayerCount)/11"
        setSelectedPlayers()
        self.tblPlayer.reloadData()
        
    }
    
  
    func selectPlayer(cell: TeamSelectionCell, modelItem: MatchAllPlayerData) {
        
        if(modelItem.selected ?? false){
            
         //   validatePlayer(modelItem: modelItem)
            
            cell.vwPlayer.backgroundColor = UIColor.green
            
            for i in 0..<allTeamList.count {
                if (allTeamList[i].pID == modelItem.pID) {
                    allTeamList[i].selected = true
                    break
                }
            }
        }else{
            cell.vwPlayer.backgroundColor = UIColor.white
            
            for i in 0..<allTeamList.count {
                if (allTeamList[i].pID == modelItem.pID) {
                    allTeamList[i].selected = false
                    break
                }
            }
        }
        
        editFirstTime = false
        setData(refreshCall: false)
    }

    
    func validatePlayer(modelItem: MatchAllPlayerData){
       
        // - - -  minimum player selection check
        if (totalKeeper < minKeeper) {
            btnNext.isEnabled = false
            btnNext.alpha = 0.5
            return
        }
        
        if (totalBatsman < minBatsman) {
            btnNext.isEnabled = false
            btnNext.alpha = 0.5
            return
        }
        
        if (totalAllRounder < minAllRounder) {
            btnNext.isEnabled = false
            btnNext.alpha = 0.5
            return
        }
        
        if (totalBowler < minBowler) {
            btnNext.isEnabled = false
            btnNext.alpha = 0.5
            return
        }
        
    }
    
    // - - - - -  function to update selector color of players (Dots)- - - - - - - -
    private func setSelectedPlayers() {
        var totalCount = team1 + team2
        lblPlayersCount.text = "PLAYERS \(totalCount)/11"
        
        var colors = [UIColor](repeating: UIColor(), count: 11)
       // let colors = Array(repeating: UIColor, count: 11)
        for i in 0...10 {
            colors[i] = UIColor.gray
        }


        if (team1 > 0) {
            for i in 0...team1-1 {
                colors[i] = UIColor.red
            }
        }
        
        if (team2 > 0 && totalCount > 0) {
            for i in team1...totalCount-1 {
                colors[i] = UIColor.green
            }
        }

        btnSelector1.backgroundColor = colors[0]
        btnSelector2.backgroundColor = colors[1]
        btnSelector3.backgroundColor = colors[2]
        btnSelector4.backgroundColor = colors[3]
        btnSelector5.backgroundColor = colors[4]
        btnSelector6.backgroundColor = colors[5]
        btnSelector7.backgroundColor = colors[6]
        btnSelector8.backgroundColor = colors[7]
        btnSelector9.backgroundColor = colors[8]
        btnSelector10.backgroundColor = colors[9]
        btnSelector11.backgroundColor = colors[10]

}
    
    
    @IBAction func clickPreview(_ sender: UIButton) {
       print("preview clicked")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcPreview = storyBoard.instantiateViewController(withIdentifier: "PreviewPopupController") as! PreviewPopupController
        var selectedPlayerList =  allTeamList.filter { it in
            (it.selected ?? false)
        }
        vcPreview.showHeader = false
        vcPreview.selectedPlayerList = selectedPlayerList
        self.present(vcPreview, animated: false)
        
    }
    
    
    @IBAction func clickNext(_ sender: UIButton) {
        print("clicked next")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcAddCaptain = storyBoard.instantiateViewController(withIdentifier: "AddCaptainController") as! AddCaptainController
        var selectedPlayerList =  allTeamList.filter { it in
            (it.selected ?? false)
        }
        vcAddCaptain.mid = mid
        vcAddCaptain.tid = tid
        vcAddCaptain.model = model
        vcAddCaptain.callFromScreen = callFromScreen
        vcAddCaptain.selectedPlayerList = selectedPlayerList
        self.navigationController!.pushViewController(vcAddCaptain, animated: true)
    }
 
}

extension CreateTeamController : TeamsPresentable,MatchesPresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom.elementsEqual(Constant.ALL_TEAM_PLAYERS) || callFrom.elementsEqual(Constant.SELECTED_TEAM_PLAYERS)){
            
            allTeamList = presenter.matchAllPlayerData
            
            print("All Team List - - - ",allTeamList)
            
            if(allTeamList.count > 0){
                
                createTabs()
                setData(refreshCall: refreshCall)
                setSelectedPlayers()
            }
        }
        
        
        if(callFrom.elementsEqual(Constant.RULES)){
            rules = presenterMatches.rules
            print("** ** rules ** ** - - - ",rules)
            
            if(rules.count > 0){
                var minMax = [GetRules0]()
                minMax = rules[0].minmax ?? []
                
                minKeeper = minMax.filter { $0.role == "WK" }.first?.min ?? 1
                
                maxKeeper = minMax.filter { $0.role == "WK" }.first?.max ?? 8
                
                minBatsman = minMax.filter { $0.role == "BA" }.first?.min ?? 1
                maxBatsman = minMax.filter { $0.role == "BA" }.first?.max ?? 8
                
                minBowler = minMax.filter { $0.role == "BO" }.first?.min ?? 1
                maxBowler = minMax.filter { $0.role == "BO" }.first?.max ?? 8
                
                minAllRounder = minMax.filter { $0.role == "AR" }.first?.min ?? 1
                maxAllRounder = minMax.filter { $0.role == "AR" }.first?.max ?? 8
                
                if (callFromScreen.elementsEqual("create")) {
                    presenter.matchAllPlayer(mid: mid, callFrom: Constant.ALL_TEAM_PLAYERS)
                } else {
                    presenter.selectedTeam(mid: mid, teamid: tid, callFrom: Constant.SELECTED_TEAM_PLAYERS)
                }
            }
        }
       noDataView.hideView(view: noDataView)
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.matchAllPlayer(mid: mid, callFrom: Constant.SELECTED_TEAM_PLAYERS)
       }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension CreateTeamController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visiblePlayerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellTeam = tableView.dequeueReusableCell(withIdentifier: "TeamSelectionCell", for: indexPath) as! TeamSelectionCell
        
        cellTeam.lblTeamName.text = visiblePlayerList[indexPath.row].tName ?? ""
        cellTeam.lblPlayerName.text = visiblePlayerList[indexPath.row].pName ?? ""
        cellTeam.imvJersey.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (visiblePlayerList[indexPath.row].tLogo ?? "").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        
        if(visiblePlayerList[indexPath.row].selected ?? false){
         //   cellTeam.vwPlayer.backgroundColor = UIColor.green
            cellTeam.vwPlayer.startColor = UIColor.init(named: "selectedDarkGreen") ?? .green
            cellTeam.vwPlayer.endColor = UIColor.init(named: "selectedLightGreen") ?? .green
        }else{
         //   cellTeam.vwPlayer.backgroundColor = UIColor.white
            cellTeam.vwPlayer.startColor = UIColor.init(named: "defaultLightGray") ?? .lightGray
            cellTeam.vwPlayer.endColor = UIColor.init(named: "defaultBorderColor") ?? .lightGray
        }
        
        
        if (visiblePlayerList[indexPath.row].play == 1) {
            cellTeam.vwHighlightPlayer.isHidden = false
        }else{
            cellTeam.vwHighlightPlayer.isHidden = true
        }
        
        cellTeam.totalBatsman = totalBatsman
        cellTeam.totalBowler = totalBowler
        cellTeam.totalAllRounder = totalAllRounder
        cellTeam.totalKeeper = totalKeeper
        
        cellTeam.maxBatsman = maxBatsman
        cellTeam.maxBowler = maxBowler
        cellTeam.maxAllRounder = maxAllRounder
        cellTeam.maxKeeper = maxKeeper
        
        cellTeam.finalPlayerCount = finalPlayerCount
        
        cellTeam.selectedPlayer = visiblePlayerList[indexPath.row]
        cellTeam.delegate = self
        
        return cellTeam
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
   
}


extension CreateTeamController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        
        let vc = UIViewController()
        
        if(position != -1)
        {
            initPosition = position
            setData(refreshCall: false)
            
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

extension CreateTeamController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}

extension CreateTeamController:HandleHeaderBack{
    func onBackClick() {
        print("Clicked back")
        self.navigationController?.popViewController(animated: true)
    }
    
    func onTimeOut() {
        let alert = UIAlertController(title: "", message: "Deadline has passed. Match is Live!!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.openViewControllerBasedOnIdentifier("DashboardViewController", "Home")
        }))
        
        self.present(alert, animated: false, completion: nil)
    }
    
    func onAboutMatch() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
        let vcAboutMatch = storyBoard.instantiateViewController(withIdentifier: "AboutMatchController") as! AboutMatchController
        vcAboutMatch.mid = model?.mID ?? -1
        vcAboutMatch.callFrom = "TEAM"
        vcAboutMatch.model = model
        self.present(vcAboutMatch, animated: true)
    }
    
}

