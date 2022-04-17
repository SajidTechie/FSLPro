//
//  LeagueEntryDetailController.swift
//  Dummy
//
//  Created by Goldmedal on 01/11/21.
//

import UIKit

class LeagueEntryDetailController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    private var presenter: iLeaguePresenter!
    @IBOutlet weak var header : HeaderWithTimer!
    @IBOutlet weak var noDataView : NoDataView!
    private var leagueEntryData: [LeagueEntryDetailsData] = []
    
    var mid = Int()
    var lid = Int()
    var model: Match?
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        refreshControl.endRefreshing()
            self.presenter.getLeagueEntryDetail(mid: self.mid, lid: self.lid, callFrom: Constant.LEAGUE_ENTRY_DETAILS)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.header.bindHeader(model: model)
        header.delegate = self
     
        presenter = LeaguePresenter(view: self)
        presenter.initInteractor()
        presenter.getLeagueEntryDetail(mid: mid, lid: lid, callFrom: Constant.LEAGUE_ENTRY_DETAILS)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if #available(iOS 10.0, *){
            tableView.refreshControl = refreshControl
        }else{
            tableView.addSubview(refreshControl)
        }
    }
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
}



extension LeagueEntryDetailController : LeaguePresentable {
    func willLoadData(callFrom:String) {
         noDataView.showView(view: noDataView, from: "LOADER", msg: "")
    }
    
    func didLoadData(callFrom:String){
        
        if(callFrom == Constant.LEAGUE_ENTRY_DETAILS){
            leagueEntryData = presenter.leagueEntryDetail
            print("** ** leagueEntryDetail data ** ** - - - ",leagueEntryData)
            if(leagueEntryData.count>0){
                self.tableView.reloadData()
                noDataView.hideView(view: noDataView)
            }else{
                noDataView.showView(view: noDataView, from: "", msg: "")
            }
            
        }
      
    }
    
    func didFail(error: CustomError,callFrom:String) {
        print("API error  -- - - -",error)
        
        if error.localizedDescription.elementsEqual(StringConstants.token_expired) {
            print("TOKEN ERROR")
            //Refresh API
            presenter.getLeagueEntryDetail(mid: mid, lid: lid, callFrom: Constant.LEAGUE_ENTRY_DETAILS)
       }else{ noDataView.showView(view: self.noDataView, from: "", msg: error.localizedDescription)}
    }
}


extension LeagueEntryDetailController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueEntryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueStatsCell", for: indexPath) as! LeagueStatsCell
    
        cell.lblPlayerName.text = leagueEntryData[indexPath.row].dN ?? ""
        
        cell.imvCountry.sd_setImage(with: URL(string: Constant.WEBSITE_URL + ("/\(leagueEntryData[indexPath.row].flg ?? "")").replace(string: " ", replacement: "%20")), placeholderImage: UIImage(named: Constant.NO_IMAGE_HOME_ICON))
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.init(named: "cardBackground") ?? .lightGray
        }
        else {
            cell.backgroundColor = UIColor.white
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension LeagueEntryDetailController:HandleHeaderBack{
    func onBackClick() {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func onTimeOut() {
        let alert = UIAlertController(title: "", message: "Deadline has passed. Match is Live!!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.dismiss(animated: false, completion: nil)
        }))
        
        self.present(alert, animated: false, completion: nil)
    }
    
}
