//
//  LiveTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class LiveTabController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    private var presenter: iMatchesPresenter!
    private var matchesList: [Match] = []
    private var liveScoreObj: [LiveScoreData] = []
    private var liveScoreMainArr: [LiveScoreData] = []
   
    var timer: Timer?
    
    var callLiveMatch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MatchesPresenter(view: self)
        presenter.initInteractor()
        presenter.getMatches(mid: 1)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // @objc selector expected for Timer
    @objc func update() {
        // do what should happen when timer triggers an event
        updateLiveScoreApi()
        
    }
    
    
    func updateLiveScoreApi(){
        if(matchesList.count > 0){
          //  liveScoreMainArr.removeAll()
            for i in 0...(matchesList.count - 1) {
                presenter.getLiveScore(mid: matchesList[i].mID ?? 0,position:i)
            }
            
            callLiveMatch = true
            
        }
    }
    
    
}



extension LiveTabController : MatchesPresentable {
    func willLoadData() {
    }
    
    func didLoadData() {
        
        if(callLiveMatch == false)
        {
            matchesList = presenter.matches
       
            for i in 0...(matchesList.count - 1) {
                
                liveScoreMainArr.insert(LiveScoreData(groupName: matchesList[i].groupName ?? "-", matchDate: matchesList[i].matchDate ?? "-", matchName: matchesList[i].matchName ?? "-", mID: matchesList[i].mID ?? 0, position:i, season: matchesList[i].season ?? "-", status: matchesList[i].status ?? 0, teamA: matchesList[i].teamA ?? "-", teamALogo: matchesList[i].teamALogo ?? "-", teamB: matchesList[i].teamB ?? "-", teamBLogo: matchesList[i].teamBLogo ?? "-",teamAScore: "",teamBScore: "",venue: matchesList[i].venue ?? "-"), at: i)
            }
            
           // updateLiveScoreApi()
            
            timer = Timer.scheduledTimer(timeInterval: 5,
                                 target: self,
                                 selector: #selector(self.update),
                                 userInfo: nil,
                                 repeats: true)
        }
        
        
        if(callLiveMatch == true)
        {
            liveScoreObj = presenter.liveScore
            
            let position = presenter.liveMatchesPosition
            if(liveScoreObj.count > 0){
                liveScoreObj[0].position = position
                liveScoreMainArr[position].teamAScore = liveScoreObj[0].teamAScore
                liveScoreMainArr[position].teamBScore = liveScoreObj[0].teamBScore
           
                liveScoreMainArr.sorted(by: { $0.position < $1.position })
                
               
            }
           
            
          
        }
        
        print("** ** live matches ** ** - - - ",matchesList)
        print("** ** liveScoreMainArr** ** - - - ",liveScoreMainArr)
        
        if (liveScoreMainArr.count > 0){
            self.tableView.reloadData()
        }
        
        
    }
    
    
    
    func didFail(error: CustomError) {
        
    }
}


extension LiveTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedViewCell", for: indexPath) as! CompletedViewCell
        cell.lblTeamA.text = liveScoreMainArr[indexPath.row].teamA ?? ""
        cell.lblTeamB.text = liveScoreMainArr[indexPath.row].teamB ?? ""
        cell.lblLeague.text = liveScoreMainArr[indexPath.row].season
        cell.lblMatch.text = liveScoreMainArr[indexPath.row].groupName
        
        cell.imvTeamALogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (liveScoreMainArr[indexPath.row].teamALogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        cell.imvTeamBLogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (liveScoreMainArr[indexPath.row].teamALogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        
        if(liveScoreMainArr[indexPath.row].teamAScore?.contains(",") == true){
            let teamA = liveScoreMainArr[indexPath.row].teamAScore?.split(separator: ",")
            if(teamA?.count ?? 0 > 0){
                cell.lblTeamAScore1.text = String(teamA?[0] ?? "-")
                cell.lblTeamAScore2.text = String(teamA?[1] ?? "-")
            }else{
                cell.lblTeamAScore1.text = liveScoreMainArr[indexPath.row].teamAScore
            }
        }else{
            cell.lblTeamAScore1.text = liveScoreMainArr[indexPath.row].teamAScore
        }
        
        if(liveScoreMainArr[indexPath.row].teamBScore?.contains(",") == true){
            let teamB = liveScoreMainArr[indexPath.row].teamBScore?.split(separator: ",")
            if(teamB?.count ?? 0 > 0){
                cell.lblTeamBScore1.text = String(teamB?[0] ?? "-")
                cell.lblTeamBScore2.text = String(teamB?[1] ?? "-")
            }else{
                cell.lblTeamBScore1.text = liveScoreMainArr[indexPath.row].teamBScore
            }
        }else{
            cell.lblTeamBScore1.text = liveScoreMainArr[indexPath.row].teamBScore
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
