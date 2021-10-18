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
    
    func getRules()
    var rules: [GetRulesData] {get set}
    
    func getMatches(mid:Int)
    var matches: [Match] {get set}
    
    func getLiveMatches(mid:Int,position:Int)
    var liveMatches: [Match] {get set}
    
    func getLiveScore(mid:Int,position:Int)
    var liveScore: [LiveScoreData] {get set}
  
    var liveMatchesPosition: Int {get set}
}

class MatchesPresenter: iMatchesPresenter {
    var liveMatchesPosition: Int = 0
    var rules: [GetRulesData] = []
    var matches: [Match] = []
    var liveMatches: [Match] = []
    var liveScore: [LiveScoreData] = []
    
    weak var view: MatchesPresentable?
    var interactor: iMatchesInteractor!
    
    required init(view: Presentable) {
        self.view = view as? MatchesPresentable
    }
    
    func initInteractor() {
        interactor = MatchesInteractor(presenter: self)
    }
    
    
    func getMatches(mid:Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.fetchAllMatches(mid: mid)
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
    
    
    func getLiveMatches(mid:Int,position:Int)  {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.fetchAllLiveMatches(mid: mid, position: position)
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
    
    
    func getRules() {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.getMatchRules()
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
    
    
    
    func getLiveScore(mid: Int,position:Int) {
        view?.willLoadData()
        if (Reachability.isConnectedToNetwork()) {
            do {
                try interactor.fetchLiveScore(mid: mid,position:position)
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


extension MatchesPresenter: MatchesInteractable {
    func didFinishFetchingDataWithPosition(list: [Any], position: Int) {
        liveMatches = list as? [Match] ?? []
        liveScore = list as? [LiveScoreData] ?? []
        liveMatchesPosition = position
        view?.didLoadData()
    }
    
    func didFinishFetchingData(list: [Any]) {
        matches = list as? [Match] ?? []
        rules = list as? [GetRulesData] ?? []
        view?.didLoadData()
    }
    
   
    
    func didFailFetchingData(error: CustomError) {
        view?.didFail(error: error)
    }
}
