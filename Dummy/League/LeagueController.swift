//
//  LeagueController.swift
//  Dummy
//
//  Created by Goldmedal on 23/09/21.
//

import UIKit
import XLPagerTabStrip

class LeagueController: PagerStripController,CommonDelegate {
    
    //ViewPagerControllerDelegate
   @IBOutlet weak var header : HeaderWithTimer!
    var mid = Int()
    
    var model: Match?
 
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(leagueUpdate(_:)), name: NSNotification.Name("LEAGUE_TAB"), object: nil)

        self.header.bindHeader(model: model)
       header.delegate = self
        
        super.viewDidLoad()
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    

    @objc func leagueUpdate(_ notification:Notification){
        moveToViewController(at: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.reloadPagerTabStripView()
      super.viewWillAppear(animated)
        
      
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
        let storyBoardTeam: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let leaguesTab = storyBoard.instantiateViewController(withIdentifier: "LeaguesTabController") as! LeaguesTabController
        leaguesTab.delegate = self
        leaguesTab.mid = mid
        leaguesTab.model = model
        
        let myTeam = storyBoardTeam.instantiateViewController(withIdentifier: "MyTeamTabController") as! MyTeamTabController
        myTeam.mid = mid
        myTeam.model = model
        
        let myLeagues = storyBoard.instantiateViewController(withIdentifier: "MyLeaguesTabController") as! MyLeaguesTabController
        myLeagues.mid = mid
        myLeagues.model = model
        
        let childViewControllers = [leaguesTab, myTeam, myLeagues]
        let count = childViewControllers.count

        
        return Array(childViewControllers.prefix(Int(count)))
        
    }
    
    func refreshApi() {
        print("Refresh header is called")
        header.bindHeader(model: model)
    }

}


extension LeagueController:HandleHeaderBack{
    func onBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onTimeOut() {
        let alert = UIAlertController(title: "", message: "Deadline has passed. Match is Live!!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.navigationController?.popViewController(animated: false)
        }))
        
        self.present(alert, animated: false, completion: nil)
    }
    
    func onAboutMatch() {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
        let vcAboutMatch = storyBoard.instantiateViewController(withIdentifier: "AboutMatchController") as! AboutMatchController
        vcAboutMatch.mid = mid
        vcAboutMatch.callFrom = "LEAGUES"
        vcAboutMatch.model = model
        self.present(vcAboutMatch, animated: true)
    }
    
}
