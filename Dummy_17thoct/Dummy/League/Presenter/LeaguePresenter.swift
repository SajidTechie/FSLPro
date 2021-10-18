//
//  LeaguePresenter.swift
//  Dummy
//
//  Created by Goldmedal on 24/09/21.
//

import Foundation
protocol LeaguePresentable: Presentable {
    
}

protocol iLeaguePresenter: iPresenter {
    var view: LeaguePresentable? {get set}

    func getLeaguesForMatch(mid:Int)
    var leagueForMatch: [LeagueDetailData] {get set}
    

    func getMyTeam(mid:Int)
    var myTeam: [MyTeamNameData] {get set}
    
    func joinLeague(mid: Int,lid: Int,teamid: Int)
    var joinLeague: [JoinedLeagueData] {get set}
    
    
    func getMyJoinedLeagues(mid:Int)
    var myJoinedLeagues: [MyJoinedLeagueData] {get set}
    
    
    func getMyJoinedLeagueDetail(mid: Int,lid: Int)
    var myJoinedLeagueDetail: [LeagueDetailData] {get set}
  
}

class LeaguePresenter: iLeaguePresenter {
    
    
    var myTeam: [MyTeamNameData] = []
    var joinLeague: [JoinedLeagueData] = []
    var leagueForMatch: [LeagueDetailData] = []
    var myJoinedLeagues: [MyJoinedLeagueData] = []
    var myJoinedLeagueDetail: [LeagueDetailData] = []
    
    
    
    weak var view: LeaguePresentable?
    var interactor: iLeagueInteractor!
    
    required init(view: Presentable) {
        self.view = view as? LeaguePresentable
    }
    
    func initInteractor() {
        interactor = LeagueInteractor(presenter: self)
    }
    
    
    
    func getLeaguesForMatch(mid:Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.leagueForMatch(mid: mid)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err))
            }
        }
    
    }
    
    func getMyTeam(mid:Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMyTeam(mid: mid)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err))
            }
        }
    
    }
    
    func joinLeague(mid: Int,lid: Int,teamid: Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.joinLeague(mid: mid,lid:lid,teamid:teamid)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err))
            }
        }
    }
    
    func getMyJoinedLeagues(mid:Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMyJoinedLeagues(mid: mid)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err))
            }
        }
    
    }
    
    func getMyJoinedLeagueDetail(mid: Int,lid: Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMyJoinedLeagueDetail(mid: mid,lid:lid)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err))
            }
        }
    }
    
   

}


extension LeaguePresenter: LeagueInteractable {
    func didFinishFetchingData(list: [Any]) {
        leagueForMatch = list as? [LeagueDetailData] ?? []
        myTeam = list as? [MyTeamNameData] ?? []
        joinLeague = list as? [JoinedLeagueData] ?? []
        myJoinedLeagues = list as? [MyJoinedLeagueData] ?? []
        myJoinedLeagueDetail = list as? [LeagueDetailData] ?? []

        view?.didLoadData()
    }
    
    
    func didFailFetchingData(error: CustomError) {
        view?.didFail(error: error)
    }
}

