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
    
    func myTeamName(mid:Int,callFrom:String)
    var teamNameData: [MyTeamNameData] {get set}

    func matchAllPlayer(mid:Int,callFrom:String)
    var matchAllPlayerData: [MatchAllPlayerData] {get set}
    
    func createEditTeam(mid: Int, teamid: Int, teamDetails: [playerDetailObj],callFrom:String)
    var createEditTeamData: [CreateEditTeamData] {get set}
    
    func selectedTeam(mid: Int, teamid: Int,callFrom:String)
    var selectedTeamData: [MatchAllPlayerData] {get set}

    func teamPoints(mid: Int, teamid: Int,callFrom:String)
    var teamPointsData: [TeamPointsData] {get set}
    
    func teamRank(mid:Int,callFrom:String)
    var teamRankData: [TeamRank] {get set}
  
}

class TeamsPresenter: iTeamsPresenter {
   
    var teamNameData: [MyTeamNameData] = []
    
    var matchAllPlayerData: [MatchAllPlayerData] = []
    
    var createEditTeamData: [CreateEditTeamData] = []
    
    var selectedTeamData: [MatchAllPlayerData] = []
    
    var teamPointsData: [TeamPointsData] = []
    
    var teamRankData: [TeamRank] = []
    
  
    weak var view: TeamsPresentable?
    var interactor: iTeamsInteractor!
    
    required init(view: Presentable) {
        self.view = view as? TeamsPresentable
    }
    
    func initInteractor() {
        interactor = TeamsInteractor(presenter: self)
    }
    
    
    
    func myTeamName(mid: Int,callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
    
            do {
                try interactor.myTeamName(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)

            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    }
    

    func matchAllPlayer(mid: Int,callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
      
            do {
                try interactor.matchAllPlayer(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)

            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    }
    
    func createEditTeam(mid: Int, teamid: Int, teamDetails: [playerDetailObj],callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
      
            do {
                try interactor.createEditTeam(mid: mid, teamid: teamid, teamDetails: teamDetails,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)

            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    }
    
    func selectedTeam(mid: Int, teamid: Int,callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
       
            do {
                try interactor.selectedTeam(mid: mid, teamid: teamid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)

            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    }
    
    func teamPoints(mid: Int, teamid: Int,callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
      
            do {
                try interactor.teamPoints(mid: mid, teamid: teamid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)

            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    }
    
    func teamRank(mid: Int,callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
      
            do {
                try interactor.teamRank(mid: mid,callFrom:callFrom)
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


extension TeamsPresenter: TeamsInteractable {
    func didFinishFetchingData(list: [Any],callFrom:String) {
     
        matchAllPlayerData = list as? [MatchAllPlayerData] ?? []
        selectedTeamData = list as? [MatchAllPlayerData] ?? []
        teamPointsData = list as? [TeamPointsData] ?? []
        teamNameData = list as? [MyTeamNameData] ?? []
        createEditTeamData = list as? [CreateEditTeamData] ?? []
        teamRankData = list as? [TeamRank] ?? []
   
        view?.didLoadData(callFrom: callFrom)
    }
    
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}
