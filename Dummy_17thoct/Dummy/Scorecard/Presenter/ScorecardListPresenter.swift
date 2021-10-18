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
     
    func getScorecard(mid:Int)
    var scorecard: [ScorecardMain] {get set}
    
    func getMatchInfo(mid:Int)
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
    
    
    
    func getScorecard(mid:Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getScorecard(mid: mid)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err))
            }
        }
        else {
            
        }
    }
    
   
    func getMatchInfo(mid:Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMatchInfo(mid: mid)
            }
            catch
                CustomError.DatabaseError {
                    view?.didFail(error: CustomError.DatabaseError)
                    
            }
            catch let err {
                view?.didFail(error: CustomError.HTTPError(err: err))
            }
        }
        else {
            
        }
    }
    
}


extension ScorecardListPresenter: ScorecardListInteractable {
    func didFinishFetchingData(list: [Any]) {
        scorecard = list as? [ScorecardMain] ?? []
        matchInfo = list as? [MatchData] ?? []
        view?.didLoadData()
    }
    
    func didFailFetchingData(error: CustomError) {
        view?.didFail(error: error)
    }
}
