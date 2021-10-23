//
//  UpcomingTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit
import SDWebImage

class UpcomingTabController: UIViewController  {
    
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iMatchesPresenter!
    private var matchesList: [Match] = []
    
    let Dateformatter = DateFormatter()
    var strMatchDate = ""
    var strCurrDate = ""
    var currentDate = Date()
    var matchDate = Date()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        presenter = MatchesPresenter(view: self)
        presenter.initInteractor()
        
        // - - - To get upcoming data - - - -
        presenter.getMatches(mid: 0, callFrom: Constant.UPCOMING_MATCHES)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    func setTimer(cell:UpcomingViewCell,row:Int){
        self.strMatchDate = self.matchesList[row].matchDate ?? "0000-00-00T00:00:00"
        self.strCurrDate = self.Dateformatter.string(from: Date())
        
        //convert string to date
        self.currentDate = self.Dateformatter.date(from: self.strCurrDate)!
        self.matchDate = self.Dateformatter.date(from: self.strMatchDate)!
        
        var timeLeft = self.calendar.dateComponents([.second], from:self.currentDate, to:self.matchDate).second
        // print("Difference - - - -",timeLeft)
        
        if(timeLeft ?? 0 > 0){
            cell.lblTimer.text = Utility.init().timeFormatted(timeLeft ?? 0)
        }else{
            cell.lblTimer.text = "-:-:-"
        }
        
    }
    
    
}



extension UpcomingTabController : MatchesPresentable {
    func willLoadData(callFrom:String) {
        
    }
    
    func didLoadData(callFrom:String){
        matchesList = presenter.matches
        print("** ** upcoming matches ** ** - - - ",matchesList)
        
        UIView.performWithoutAnimation {
            self.tableView.reloadData()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
    }
    
    func didFail(error: CustomError,callFrom:String) {
        
    }
}


extension UpcomingTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingViewCell", for: indexPath) as! UpcomingViewCell
        cell.lblTeamA.text = matchesList[indexPath.row].teamA
        cell.lblTeamB.text = matchesList[indexPath.row].teamB
        cell.lblLeague.text = matchesList[indexPath.row].season
        cell.lblMatch.text = matchesList[indexPath.row].groupName
        
        
        cell.imvTeamALogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamALogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        
        cell.imvTeamBLogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamBLogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_AWAY_ICON))
        
        self.setTimer(cell: cell, row: indexPath.row)
        
        cell.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.setTimer(cell: cell, row: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? UpcomingViewCell
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "League", bundle: nil)
        let vcLeague = storyBoard.instantiateViewController(withIdentifier: "LeagueController") as! LeagueController
        vcLeague.mid = self.matchesList[indexPath.row].mID ?? 0
        
        if(cell?.countdownTimer != nil){
            cell?.countdownTimer?.invalidate()
            cell?.countdownTimer = nil
        }
        
        self.navigationController!.pushViewController(vcLeague, animated: true)
        
        // self.navigationController!.pushViewController(vcLeague, animated: true)
    }
    
}

