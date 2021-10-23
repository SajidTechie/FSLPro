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

    func getLeaguesForMatch(mid:Int,callFrom:String)
    var leagueForMatch: [LeagueDetailData] {get set}
    

    func getMyTeam(mid:Int,callFrom:String)
    var myTeam: [MyTeamNameData] {get set}
    
    func joinLeague(mid: Int,lid: Int,teamid: Int,callFrom:String)
    var joinLeague: [JoinedLeagueData] {get set}
    
    
    func getMyJoinedLeagues(mid:Int,callFrom:String)
    var myJoinedLeagues: [MyJoinedLeagueData] {get set}
    
    
    func getMyJoinedLeagueDetail(mid: Int,lid: Int,position: Int,callFrom:String)
    var myJoinedLeagueDetail: [LeagueDetailData] {get set}
    
    var leagueDetailPosition: Int {get set}
  
}

class LeaguePresenter: iLeaguePresenter {
    
    var leagueDetailPosition: Int = 0
    
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
    
    
    
    func getLeaguesForMatch(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.leagueForMatch(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        }
    
    }
    
    func getMyTeam(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMyTeam(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        }
    
    }
    
    func joinLeague(mid: Int,lid: Int,teamid: Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.joinLeague(mid: mid,lid:lid,teamid:teamid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        }
    }
    
    func getMyJoinedLeagues(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMyJoinedLeagues(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        }
    
    }
    
    func getMyJoinedLeagueDetail(mid: Int,lid: Int, position: Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMyJoinedLeagueDetail(mid: mid,lid:lid,position: position,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        }
    }
    
   

}


extension LeaguePresenter: LeagueInteractable {
    
    func didFinishFetchingDataWithPosition(list: [Any], position: Int,callFrom:String) {
        myJoinedLeagueDetail = list as? [LeagueDetailData] ?? []
        leagueDetailPosition = position
        view?.didLoadData(callFrom: callFrom)
    }
    
    func didFinishFetchingData(list: [Any],callFrom:String) {
        leagueForMatch = list as? [LeagueDetailData] ?? []
        myTeam = list as? [MyTeamNameData] ?? []
        joinLeague = list as? [JoinedLeagueData] ?? []
        myJoinedLeagues = list as? [MyJoinedLeagueData] ?? []
        

        view?.didLoadData(callFrom: callFrom)
    }
    
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}

