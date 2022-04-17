//
//  MatchesListPresenter.swift
//  Dummy
//
//  Created by Goldmedal on 18/09/21.
//

import Foundation
import UIKit

protocol MatchesPresentable: Presentable {
    
}

protocol iMatchesPresenter: iPresenter {
    var view: MatchesPresentable? {get set}
    
    func getTeamRank(mid:Int,callFrom:String)
    var myTeamRank: [TeamRank] {get set}
    
    func getRules(callFrom:String)
    var rules: [GetRulesData] {get set}
    
    func getMatches(mid:Int,callFrom:String)
    var matches: [Match] {get set}
    
    func getLiveMatches(mid:Int,position:Int,callFrom:String)
    var liveMatches: [Match] {get set}
    
    func getLiveScore(mid:Int,position:Int,callFrom:String)
    var liveScore: [LiveScoreData] {get set}
  
    var liveMatchesPosition: Int {get set}
}

class MatchesPresenter: iMatchesPresenter {
    var liveMatchesPosition: Int = 0
    var rules: [GetRulesData] = []
    var matches: [Match] = []
    var liveMatches: [Match] = []
    var liveScore: [LiveScoreData] = []
    var myTeamRank: [TeamRank] = []
    
    weak var view: MatchesPresentable?
    var interactor: iMatchesInteractor!
    
    required init(view: Presentable) {
        self.view = view as? MatchesPresentable
    }
    
    func initInteractor() {
        interactor = MatchesInteractor(presenter: self)
    }
    
    
    func getMatches(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
       
            do {
                try interactor.fetchAllMatches(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
     
    }
    
    
    func getTeamRank(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
    
            do {
                try interactor.getTeamRank(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    
    }
    
    
    func getLiveMatches(mid:Int,position:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
    
            do {
                try interactor.fetchAllLiveMatches(mid: mid, position: position,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
     
    }
    
    
    func getRules(callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
   
            do {
                try interactor.getMatchRules(callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        
    }
    
    
    
    func getLiveScore(mid: Int,position:Int,callFrom:String) {
        view?.willLoadData(callFrom:callFrom)
      
            do {
                try interactor.fetchLiveScore(mid: mid,position:position,callFrom:callFrom)
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


extension MatchesPresenter: MatchesInteractable {
    func didFinishFetchingDataWithPosition(list: [Any], position: Int,callFrom:String) {
        liveMatches = list as? [Match] ?? []
        liveScore = list as? [LiveScoreData] ?? []
        liveMatchesPosition = position
        view?.didLoadData(callFrom: callFrom)
    }
    
    func didFinishFetchingData(list: [Any],callFrom:String) {
        matches = list as? [Match] ?? []
        rules = list as? [GetRulesData] ?? []
        myTeamRank = list as? [TeamRank] ?? []
        view?.didLoadData(callFrom: callFrom)
    }
    
   
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}
