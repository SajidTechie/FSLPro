//
//  ViewController.swift
//  Dummy
//
//  Created by Goldmedal on 15/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var presenter: iAuthPresenter!
    private var refreshToken: [InitialToken] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = AuthPresenter(view: self)
        presenter.initInteractor()
        
        let mobileNo = UserDefaults.standard.value(forKey: "MobileNumber") as? String ?? ""
        let deviceDetail = "\(UIDevice().type.rawValue) (\(Utility.getDeviceId() ?? ""))"
        
        
        // Do any additional setup after loading the view.
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//        self.navigationController!.pushViewController(vcHome, animated: true)
        
        
        
        
        if(!Utility.getToken().isEmpty){
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//                   let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//            self.present(vcHome, animated: true, completion: nil)

            presenter.refreshToken(phoneNo: mobileNo, deviceId: deviceDetail, callFrom: Constant.TOKEN_REFRESH)
        }else{
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                    let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                    self.present(vcLogin, animated: true, completion: nil)
           
        }
        
        
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
//        let vcHome = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
//        self.present(vcHome, animated: true, completion: nil)
        
        
        
       // self.navigationController!.pushViewController(vcHome, animated: true)
        
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

extension ViewController : AuthPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
   
        
        if(callFrom == Constant.TOKEN_REFRESH){
            refreshToken = presenter.refreshToken
            var token = refreshToken[0].accessToken ?? ""
            var time = refreshToken[0].expiresIn ?? 0 // - - - -  incase if we need to call this in splash
         
            UserDefaults.standard.set(token, forKey: "Token")
          
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                   let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            self.navigationController?.pushViewController(vcHome, animated: true)
      
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


