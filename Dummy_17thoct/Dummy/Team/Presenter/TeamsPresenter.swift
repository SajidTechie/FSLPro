//
//  TeamsPresenter.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
import UIKit

protocol TeamsPresentable: Presentable {
    
}

protocol iTeamsPresenter: iPresenter {
    var view: TeamsPresentable? {get set}
    
    func myTeamName(mid:Int)
    var teamNameData: [MyTeamNameData] {get set}

    func matchAllPlayer(mid:Int)
    var matchAllPlayerData: [MatchAllPlayerData] {get set}
    
    func createEditTeam(mid: Int, teamid: Int)
    var createEditTeamData: [CreateEditTeamData] {get set}
    
    func selectedTeam(mid: Int, teamid: Int)
    var selectedTeamData: [SelectedTeamData] {get set}

    func teamPoints(mid: Int, teamid: Int)
    var teamPointsData: [TeamPointsData] {get set}
    
    func teamRank(mid:Int)
    var teamRankData: [TeamRankData] {get set}
  
}

class TeamsPresenter: iTeamsPresenter {
   
    var teamNameData: [MyTeamNameData] = []
    
    var matchAllPlayerData: [MatchAllPlayerData] = []
    
    var createEditTeamData: [CreateEditTeamData] = []
    
    var selectedTeamData: [SelectedTeamData] = []
    
    var teamPointsData: [TeamPointsData] = []
    
    var teamRankData: [TeamRankData] = []
    
  
    weak var view: TeamsPresentable?
    var interactor: iTeamsInteractor!
    
    required init(view: Presentable) {
        self.view = view as? TeamsPresentable
    }
    
    func initInteractor() {
        interactor = TeamsInteractor(presenter: self)
    }
    
    
    
    func myTeamName(mid: Int) {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.myTeamName(mid: mid)
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
    

    func matchAllPlayer(mid: Int) {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.matchAllPlayer(mid: mid)
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
    
    func createEditTeam(mid: Int, teamid: Int) {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.createEditTeam(mid: mid, teamid: teamid)
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
    
    func selectedTeam(mid: Int, teamid: Int) {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.selectedTeam(mid: mid, teamid: teamid)
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
    
    func teamPoints(mid: Int, teamid: Int) {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.teamPoints(mid: mid, teamid: teamid)
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
    
    func teamRank(mid: Int) {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.teamRank(mid: mid)
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


extension TeamsPresenter: TeamsInteractable {
    func didFinishFetchingData(list: [Any]) {
     
        matchAllPlayerData = list as? [MatchAllPlayerData] ?? []
        selectedTeamData = list as? [SelectedTeamData] ?? []
        teamPointsData = list as? [TeamPointsData] ?? []
        teamNameData = list as? [MyTeamNameData] ?? []
        createEditTeamData = list as? [CreateEditTeamData] ?? []
        teamRankData = list as? [TeamRankData] ?? []
   
        view?.didLoadData()
    }
    
    
    func didFailFetchingData(error: CustomError) {
        view?.didFail(error: error)
    }
}
