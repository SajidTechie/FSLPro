//
//  CompletedTabController.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import UIKit

class CompletedTabController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iMatchesPresenter!
    private var matchesList: [Match] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        presenter = MatchesPresenter(view: self)
        presenter.initInteractor()
        presenter.getMatches(mid: 2)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    
}



extension CompletedTabController : MatchesPresentable {
    func willLoadData() {
    
    }
    
    func didLoadData() {
        matchesList = presenter.matches
     
        print("** ** completed matches ** ** - - - ",matchesList)
       
        self.tableView.reloadData()
     
    }
    
    func didFail(error: CustomError) {
   
    }
}


extension CompletedTabController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedViewCell", for: indexPath) as! CompletedViewCell
//        cell.lblTeamA.text = "\(matchesList[indexPath.row].teamA ?? "")/\(matchesList[indexPath.row].teamAScore ?? "")"
//        cell.lblTeamB.text = "\(matchesList[indexPath.row].teamB ?? ""))/\(matchesList[indexPath.row].teamBScore ?? "")"
        cell.lblLeague.text = matchesList[indexPath.row].season
        cell.lblMatch.text = matchesList[indexPath.row].groupName
        
        cell.imvTeamALogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamALogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        cell.imvTeamBLogo.sd_setImage(with: URL(string: Constant.WEBSITE_URL + (matchesList[indexPath.row].teamALogo ?? "")), placeholderImage: UIImage(named: Constant.NO_IMAGE_ICON))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

