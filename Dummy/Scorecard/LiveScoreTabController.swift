//
//  LiveScoreController.swift
//  Dummy
//
//  Created by Goldmedal on 06/10/21.
//

import UIKit

class LiveScoreTabController: UIViewController {
    
    
    @IBOutlet weak var lblBattingText1 : UILabel!
    @IBOutlet weak var lblBattingRuns1 : UILabel!
    @IBOutlet weak var lblBattingBalls1 : UILabel!
    @IBOutlet weak var lblBatting4s1 : UILabel!
    @IBOutlet weak var lblBatting6s1 : UILabel!
    @IBOutlet weak var lblBattingSr1 : UILabel!
    
    @IBOutlet weak var lblBattingText2 : UILabel!
    @IBOutlet weak var lblBattingRuns2 : UILabel!
    @IBOutlet weak var lblBattingBalls2 : UILabel!
    @IBOutlet weak var lblBatting4s2 : UILabel!
    @IBOutlet weak var lblBatting6s2 : UILabel!
    @IBOutlet weak var lblBattingSr2 : UILabel!
    
    @IBOutlet weak var lblBowlingText : UILabel!
    @IBOutlet weak var lblBowlingEco : UILabel!
    @IBOutlet weak var lblBowlingMaidens : UILabel!
    @IBOutlet weak var lblBowlingOvers : UILabel!
    @IBOutlet weak var lblBowlingRuns : UILabel!
    @IBOutlet weak var lblBowlingWickets : UILabel!
    
    @IBOutlet weak var lblActiveTeamName : UILabel!
    @IBOutlet weak var lblActiveScore : UILabel!
    @IBOutlet weak var lblActiveRunrate : UILabel!
    
    @IBOutlet weak var lblOtherTeamName : UILabel!
    @IBOutlet weak var lblOtherScore : UILabel!
    @IBOutlet weak var lblOtherRunrate : UILabel!
    
    var callFrom = ""
    private var scorecard: [ScorecardMain] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        if(callFrom.elementsEqual("LIVE")){
            NotificationCenter.default.addObserver(self, selector: #selector(liveScoreUpdate(_:)), name: NSNotification.Name("LIVE_SCORE"), object: nil)
        }
    }
    
    
    @objc func liveScoreUpdate(_ notification:Notification){
        
        let scorecardObj = notification.userInfo as! Dictionary<String,AnyObject>
        
        scorecard = scorecardObj["scorecard"] as? [ScorecardMain] ?? []
        print("LIVE SCORECARD - - - - - ",scorecard)
        
        if(!scorecard.isEmpty)
        {bindUI()}
        
    }
    
    func bindUI(){
        
        let scorecardList = scorecard[0].score
        var teamScore: ScorecardScore? = nil
        
        let checkSize = (scorecardList?.count ?? 0) - 1
        
        if (checkSize >= 0) {
            teamScore = scorecardList?[checkSize]
            setRunRate(
                firstScore: teamScore, secondScore: (checkSize > 0) ? scorecardList?[checkSize - 1] : nil
            )
        }
        
        
        if (scorecardList?.count == 0) {
            lblActiveTeamName.text = scorecard[0].info?.lt?.name
            lblOtherTeamName.text = scorecard[0].info?.vt?.name
            lblActiveScore.text = scorecard[0].info?.lt?.score
            lblOtherScore.text = scorecard[0].info?.vt?.score
        }
        
        if (scorecardList?.count == 1) {
            lblActiveTeamName.text = scorecardList?[0].bat?[0].t
            lblActiveScore.text = "\(String(scorecardList?[0].total ?? 0))/\(scorecardList?[0].wickets ?? 0))(\(scorecardList?[0].overs ?? 0)"
        }
        
        if (scorecardList?.count == 2) {
            
            lblActiveTeamName.text = scorecardList?[1].bat?[0].t
            lblActiveScore.text = "\(String(scorecardList?[1].total ?? 0))/\(scorecardList?[1].wickets ?? 0))(\(scorecardList?[1].overs ?? 0)"
            
            lblOtherTeamName.text =
                scorecardList?[0].bat?[0].t
            lblOtherScore.text = "\(String(scorecardList?[0].total ?? 0))/\(scorecardList?[0].wickets ?? 0))(\(scorecardList?[0].overs ?? 0)"
        }
        
        let checkInning: Bool
        if (scorecardList?.count ?? 0 > 2) {
            let teamName1 = scorecardList?[0].bat?[0].t
            let teamName2 = scorecardList?[0].bat?[2].t
            
            checkInning = teamName1 != teamName2
            
            if (scorecardList?.count ?? 0 == 3) {
                lblActiveTeamName.text = scorecardList?[2].bat?[0].t
                lblActiveScore.text = "\(String(scorecardList?[2].total ?? 0))/\(scorecardList?[2].wickets ?? 0))(\(scorecardList?[2].overs ?? 0)"
                
                if (checkInning) {
                    lblOtherTeamName.text = scorecardList?[1].bat?[0].t
                    lblOtherScore.text = "\(String(scorecardList?[1].total ?? 0))/\(scorecardList?[1].wickets ?? 0))(\(scorecardList?[1].overs ?? 0)"
                } else {
                    lblOtherTeamName.text = scorecardList?[0].bat?[0].t
                    lblOtherScore.text = "\(String(scorecardList?[0].total ?? 0))/\(scorecardList?[0].wickets ?? 0))(\(scorecardList?[0].overs ?? 0)"
                }
            }
            
            if (scorecardList?.count ?? 0 == 4) {
                lblActiveTeamName.text = scorecardList?[3].bat?[0].t
                lblActiveScore.text = "\(String(scorecardList?[3].total ?? 0))/\(scorecardList?[3].wickets ?? 0))(\(scorecardList?[3].overs ?? 0)"
                
                if (checkInning) {
                    lblOtherTeamName.text = scorecardList?[2].bat?[0].t
                    lblOtherScore.text = "\(String(scorecardList?[2].total ?? 0))/\(scorecardList?[2].wickets ?? 0))(\(scorecardList?[2].overs ?? 0)"
                } else {
                    lblOtherTeamName.text = scorecardList?[1].bat?[0].t
                    lblOtherScore.text = "\(String(scorecardList?[1].total ?? 0))/\(scorecardList?[1].wickets ?? 0))(\(scorecardList?[1].overs ?? 0)"
                }
            }
        }
        
        
        var batsman: [ScorecardBat] = []
        var bowl1: ScorecardBol?
        
        batsman = teamScore?.bat?.filter { it in
            (it.out == false)
        } ?? []
        
        
        let bowler = teamScore?.bol?.filter{ it in
            (it.active == true)
        } ?? []
        
        
        if (bowler.count == 1) {
            bowl1 = bowler[0]
            
            lblBowlingText.text = bowl1?.fn
            lblBowlingOvers.text = bowl1?.overs
            lblBowlingMaidens.text = String(bowl1?.medians ?? 0)
            lblBowlingRuns.text = String(bowl1?.runs ?? 0)
            lblBowlingWickets.text = String(bowl1?.wickets ?? 0)
            lblBowlingEco.text = String(bowl1?.rate ?? 0.0)
        }
        
        
        if (!batsman.isEmpty) {
            let checkActiveIndex = batsman.firstIndex(where: {$0.active == true})
            
            lblBattingText1.text = (checkActiveIndex == 0) ?"\(batsman[0].fn) *" : "\(batsman[0].fn)"
            lblBattingRuns1.text = String(batsman[0].score ?? 0)
            lblBattingBalls1.text = String(batsman[0].ball ?? 0)
            lblBatting4s1.text = String(batsman[0].four ?? 0)
            lblBatting6s1.text = String(batsman[0].six ?? 0)
            lblBattingSr1.text = String(batsman[0].rate ?? 0.0)
            
            if (batsman.count == 2) {
                lblBattingText2.text = (checkActiveIndex == 0) ?"\(batsman[1].fn) *" : "\(batsman[1].fn)"
                lblBattingRuns2.text = String(batsman[1].score ?? 0)
                lblBattingBalls2.text = String(batsman[1].ball ?? 0)
                lblBatting4s2.text = String(batsman[1].four ?? 0)
                lblBatting6s2.text = String(batsman[1].six ?? 0)
                lblBattingSr2.text = String(batsman[1].rate ?? 0.0)
            }
            
            
        }
        
    }
    
    //set current and required runrate
    func setRunRate(firstScore: ScorecardScore?, secondScore: ScorecardScore?) {
        
        let totalRunsFirst = firstScore?.total ?? 0
        let totalOversFirst = firstScore?.overs ?? 0
        
        
        var totalBallsFirst = 0
        if (String(totalOversFirst).contains(".") == true) {
            totalBallsFirst = ((Int(String(totalOversFirst).stringBefore(".")) ?? 0) * 6) + (Int(String(totalOversFirst).stringAfter(".")) ?? 0)
        } else {
            totalBallsFirst = (Int(totalOversFirst) * 6)
        }
        
        
        let totalRunsSecond = firstScore?.total ?? 0
        let totalOversSecond = secondScore?.overs ?? 0
        
        var totalBallsSecond = 0
        if (String(totalOversSecond).contains(".") == true) {
            totalBallsSecond = ((Int(String(totalOversSecond).stringBefore(".")) ?? 0) * 6) + (Int(String(totalOversSecond).stringAfter(".")) ?? 0)
        } else {
            totalBallsSecond = (Int(totalOversSecond) * 6)
        }
        
        
        if (totalRunsFirst > 0 && totalBallsFirst > 0) {
            let crr = Double(Double(totalRunsFirst)/Double(totalBallsFirst)) * 6
            lblActiveRunrate.text = "CRR \(String(format: "%.2f", crr))"
            
            if (totalRunsSecond > 0 && totalBallsSecond > 0) {
                let runDiff = Double(totalRunsFirst) - Double(totalRunsSecond)
                let ballDiff = Double(totalBallsFirst) - Double(totalBallsSecond)
                
                if (ballDiff > 0) {
                    let rrr = (runDiff/ballDiff)*6
                    
                    lblActiveRunrate.text = "CRR \(String(format: "%.2f", crr))  RRR \(String(format: "%.2f", rrr))"
                    
                }
                
            }
            
        }
    }
    
}
