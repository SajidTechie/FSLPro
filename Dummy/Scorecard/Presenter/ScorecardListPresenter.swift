//
//  ScorecardListPresenter.swift
//  Dummy
//
//  Created by Goldmedal on 19/09/21.
//

import Foundation
protocol ScorecardListPresentable: Presentable {
    
}

protocol iScorecardListPresenter: iPresenter {
    var view: ScorecardListPresentable? {get set}
     
    func getScorecard(mid:Int,callFrom:String)
    var scorecard: [ScorecardMain] {get set}
    
    func getMatchInfo(mid:Int,callFrom:String)
    var matchInfo: [MatchData] {get set}
}

class ScorecardListPresenter: iScorecardListPresenter {
    
    var scorecard: [ScorecardMain] = []
    var matchInfo: [MatchData] = []
     
    weak var view: ScorecardListPresentable?
    var interactor: iScorecardListInteractor!
    
    required init(view: Presentable) {
        self.view = view as? ScorecardListPresentable
    }
    
    func initInteractor() {
        interactor = ScorecardListInteractor(presenter: self)
    }
    
    
    
    func getScorecard(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getScorecard(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        }
        else {
            
        }
    }
    
   
    func getMatchInfo(mid:Int,callFrom:String)  {
        view?.willLoadData(callFrom:callFrom)
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMatchInfo(mid: mid,callFrom:callFrom)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError, callFrom: callFrom)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err), callFrom: callFrom)
            }
        }
        else {
            
        }
    }
    
}


extension ScorecardListPresenter: ScorecardListInteractable {
    func didFinishFetchingData(list: [Any],callFrom:String) {
        scorecard = list as? [ScorecardMain] ?? []
        matchInfo = list as? [MatchData] ?? []
        view?.didLoadData(callFrom: callFrom)
    }
    
    func didFailFetchingData(error: CustomError,callFrom:String) {
        view?.didFail(error: error,callFrom: callFrom)
    }
}
