//
//  LeagueController.swift
//  Dummy
//
//  Created by Goldmedal on 23/09/21.
//

import UIKit
import XLPagerTabStrip

class LeagueController: PagerStripController {
    
    //ViewPagerControllerDelegate
    @IBOutlet weak var header : Header!
    var mid = Int()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(leagueUpdate(_:)), name: NSNotification.Name("LEAGUE_TAB"), object: nil)

        header.delegate = self
    }
    

    @objc func leagueUpdate(_ notification:Notification){
        moveToViewController(at: 1)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
        let storyBoardTeam: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
        let leaguesTab = storyBoard.instantiateViewController(withIdentifier: "LeaguesTabController") as! LeaguesTabController
        leaguesTab.mid = mid
        let myTeam = storyBoardTeam.instantiateViewController(withIdentifier: "MyTeamTabController") as! MyTeamTabController
        myTeam.mid = mid
        let myLeagues = storyBoard.instantiateViewController(withIdentifier: "MyLeaguesTabController") as! MyLeaguesTabController
        myLeagues.mid = mid
        
        let childViewControllers = [leaguesTab, myTeam, myLeagues]
        let count = childViewControllers.count

        
        return Array(childViewControllers.prefix(Int(count)))
        
    }

}


extension LeagueController:HandleHeaderBack{
    func onBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
