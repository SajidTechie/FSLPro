//
//  CreateTeamController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class CreateTeamController: UIViewController, Presentable, TeamSelectionDelegate,CommonDelegate {
    
    
    @IBOutlet weak var tblPlayer : UITableView!
    
    @IBOutlet weak var vwHorizontalStrip: UIView!
    
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    private var presenter: iTeamsPresenter!
    
    private var allTeamList: [MatchAllPlayerData] = []
    private var batsmanList: [MatchAllPlayerData] = []
    private var bowlerList: [MatchAllPlayerData] = []
    private var wicketKeeperList: [MatchAllPlayerData] = []
    private var allRounderList: [MatchAllPlayerData] = []
    private var visiblePlayerList: [MatchAllPlayerData] = []
    
    var tabs = [ViewPagerTab]()
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = TeamsPresenter(view: self)
        presenter.initInteractor()
        presenter.matchAllPlayer(mid: mid)
        
        // - - -  fetch it from API
        maxBatsman = 7
        maxBowler = 7
        maxAllRounder = 7
        maxKeeper = 7
        
        minBatsman = 1
        minBowler = 1
        minAllRounder = 1
        minKeeper = 1
        
        createTabs()
        
        btnNext.isEnabled = false
        btnPreview.isEnabled = false
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 4)
        
        options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.imageWithText
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 13)
        options.isEachTabEvenlyDistributed = true
        options.tabViewBackgroundDefaultColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            options.tabIndicatorViewBackgroundColor = UIColor.init(named: "ColorRed") ?? UIColor.red
        } else {
            options.tabIndicatorViewBackgroundColor = UIColor.red
        }
        
        options.fitAllTabsInView = true
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = false
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        
        self.addChild(viewPager)
        self.vwHorizontalStrip.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
        
        
        self.tblPlayer.dataSource = self
        self.tblPlayer.delegate = self
      
    }
    
    
   
    
    
    func createTabs(){
        arrPositionTabs = ["WK\n\(totalKeeper)/\(maxKeeper)", "BA\n\(totalBatsman)/\(maxBatsman)", "AR\n\(totalAllRounder)/\(maxAllRounder)",  "BO\n\(totalBowler)/\(maxBowler)"]
        
        tabs.removeAll()
        
        for i in 0...(arrPositionTabs.count-1) {
            tabs.append(ViewPagerTab(title: arrPositionTabs[i], image: UIImage(named: "")))
        }
        
        if(viewPager != nil)
        { viewPager.invalidateTabs() }
    }
    
    
    func setData(){
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
        print("visiblePlayerList List - - - ",visiblePlayerList)
        
        print("TOTAL ***** ***** ",totalKeeper," - - - ",totalBatsman," - - - ",totalAllRounder," - - - ",totalBowler)
        
        finalPlayerCount = totalKeeper + totalBatsman + totalAllRounder + totalBowler
        
        if(finalPlayerCount > 0){
            btnPreview.isEnabled = true
            if(finalPlayerCount == 11){
                
                if (totalKeeper < minKeeper) {
                    btnNext.isEnabled = false
                }
                else if (totalBatsman < minBatsman) {
                    btnNext.isEnabled = false
                }
                else if (totalAllRounder < minAllRounder) {
                    btnNext.isEnabled = false
                }
                else if (totalBowler < minBowler) {
                    btnNext.isEnabled = false
                }else{
                    btnNext.isEnabled = true
                }
              
            }else{
                btnNext.isEnabled = false
            }
        }else{
            btnPreview.isEnabled = false
            btnNext.isEnabled = false
        }
        
        createTabs()
        
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
        
        setData()
        
    }

    
    func validatePlayer(modelItem: MatchAllPlayerData){
       
     
        // - - -  minimum player selection check
        if (totalKeeper < minKeeper) {
            btnNext.isEnabled = false
            return
        }
        
        if (totalBatsman < minBatsman) {
            btnNext.isEnabled = false
            return
        }
        
        if (totalAllRounder < minAllRounder) {
            btnNext.isEnabled = false
            return
        }
        
        if (totalBowler < minBowler) {
            btnNext.isEnabled = false
            return
        }
        
    }
    
    
    @IBAction func clickPreview(_ sender: UIButton) {
       print("preview clicked")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let vcPreview = storyBoard.instantiateViewController(withIdentifier: "PreviewPopupController") as! PreviewPopupController
        var selectedPlayerList =  allTeamList.filter { it in
            (it.selected ?? false)
        }
        vcPreview.selectedPlayerList = selectedPlayerList
        self.present(vcPreview, animated: true)
        
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
        vcAddCaptain.selectedPlayerList = selectedPlayerList
        self.navigationController!.pushViewController(vcAddCaptain, animated: true)
    }
    
    
    
}

extension CreateTeamController : TeamsPresentable {
    func willLoadData() {
        
    }
    
    func didLoadData() {
        
        allTeamList = presenter.matchAllPlayerData
        
        print("All Team List - - - ",allTeamList)
        
        if(allTeamList.count > 0){
            setData()
        }
        
    }
    
    func didFail(error: CustomError) {
        
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
        cellTeam.imvJersey.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (visiblePlayerList[indexPath.row].tLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        
        if(visiblePlayerList[indexPath.row].selected ?? false){
            cellTeam.vwPlayer.backgroundColor = UIColor.green
        }else{
            cellTeam.vwPlayer.backgroundColor = UIColor.white
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension CreateTeamController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        let vc = UIViewController()
        
        if(position != -1)
        {
            initPosition = position
            setData()
            
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

extension CreateTeamController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}


