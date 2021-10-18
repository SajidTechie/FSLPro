//
//  MyLeaguesTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//
//AKSHAY SHETTY
import UIKit

class MyLeaguesTabController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iLeaguePresenter!
    private var myJoinedLeagues: [MyJoinedLeagueData] = []
    private var myJoinedLeagueDetail: [LeagueDetailData] = []
    
    private var myJoinedLeagueDetailMain: [LeagueDetailData] = []
    public var mid = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        presenter.getMyJoinedLeagues(mid: 154)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
    func updateLeagueApi(){
        if(myJoinedLeagues.count > 0){
            for i in 0...(myJoinedLeagues.count - 1) {
                
                presenter.getMyJoinedLeagueDetail(mid: 154, lid: myJoinedLeagues[i].id ?? 0)
              //  group.enter()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    print("\n - - - \(self.dummArray[i]) - - - - \n")
//                }
             //   group.leave()
            }
        }
    }
    
    
    
    
    
    
}



extension MyLeaguesTabController : LeaguePresentable {
    func willLoadData() {
    
    }
    
    func didLoadData() {
        myJoinedLeagues = presenter.myJoinedLeagues
        updateLeagueApi()
        myJoinedLeagueDetail = presenter.myJoinedLeagueDetail
        
        myJoinedLeagueDetailMain.append(contentsOf: myJoinedLeagueDetail)
        
        print("** ** my leagues ** ** - - - ",myJoinedLeagues)
        print("** ** my leagues detail** ** - - - ",myJoinedLeagueDetail)
       
       self.tableView.reloadData()
     
    }
    
    func didFail(error: CustomError) {
   
    }
}


extension MyLeaguesTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myJoinedLeagueDetailMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
        
        cell.lblEntryFees.text = String(myJoinedLeagueDetailMain[indexPath.row].lEntryFees ?? 0.0)
        cell.lblLeagueName.text = myJoinedLeagueDetailMain[indexPath.row].lName
        cell.lblWinningAmnt.text = String(myJoinedLeagueDetailMain[indexPath.row].winningAmt ?? 0.0)
        
        let entriesSize = myJoinedLeagueDetailMain[indexPath.row].lMaxSize ?? 0
        let entriesJoined = myJoinedLeagueDetailMain[indexPath.row].lCurSize ?? 0
        let entriesLeft = entriesSize - entriesJoined
        
        cell.lblEntriesLeft.text = "\(entriesLeft)/\(entriesSize) LEFT"
        
        if (entriesSize > 0) {
            cell.vwProgress.setProgress(Float(Float(entriesJoined)/Float(entriesSize)), animated: true)
        }
        
        if (myJoinedLeagueDetailMain[indexPath.row].isElastic ?? false) {
            cell.vwJoin.backgroundColor = UIColor.red
        }else{
            cell.vwJoin.backgroundColor = UIColor.blue
        }
      //  cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

