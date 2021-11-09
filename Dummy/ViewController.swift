//
//  ViewController.swift
//  Dummy
//
//  Created by Goldmedal on 15/09/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//        self.navigationController!.pushViewController(vcHome, animated: true)
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vcHome = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.navigationController!.pushViewController(vcHome, animated: true)
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
//               let vcHome = storyBoard.instantiateViewController(withIdentifier: "ScorecardViewController") as! ScorecardViewController
//               self.navigationController!.pushViewController(vcHome, animated: true)
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
//               let vcAboutMatch = storyBoard.instantiateViewController(withIdentifier: "AboutMatchController") as! AboutMatchController
//               self.navigationController!.pushViewController(vcAboutMatch, animated: true)
        
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Team", bundle: nil)
//                       let vcTeamTab = storyBoard.instantiateViewController(withIdentifier: "MyTeamTabController") as! MyTeamTabController
//                       self.navigationController!.pushViewController(vcTeamTab, animated: true)
        
        
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
//               let vcTeamTab = storyBoard.instantiateViewController(withIdentifier: "LeagueController") as! LeagueController
//               self.navigationController!.pushViewController(vcTeamTab, animated: true)

//        let storyBoard: UIStoryboard = UIStoryboard(name: "Scorecard", bundle: nil)
//               let vcLiveScorecard = storyBoard.instantiateViewController(withIdentifier: "LiveScoreMainController") as! LiveScoreMainController
//               self.navigationController!.pushViewController(vcLiveScorecard, animated: true)
        
        
        
    }


}

